#!/usr/bin/env python3
""" DeepFaceLab SAE Model
    Based on https://github.com/iperov/DeepFaceLab
"""

import numpy as np

from keras.layers import Concatenate, Dense, Flatten, Input, LeakyReLU, Reshape

from lib.model.nn_blocks import Conv2DOutput, Conv2DBlock, ResidualBlock, UpscaleBlock

from ._base import ModelBase, KerasModel, logger


class Model(ModelBase):
    """ SAE Model from DFL """
    def __init__(self, *args, **kwargs):

        self._patch_weights_management(args[1])

        super().__init__(*args, **kwargs)

        self.input_shape = (self.config["input_size"], self.config["input_size"], 3)
        self.use_mask = self.config.get("learn_mask", False)
        self.multiscale_count = 3 if self.config["multiscale_decoder"] else 1
        self.encoder_dim = self.config["encoder_dims"]
        self.decoder_dim = self.config["decoder_dims"]

    @property
    def name(self):
        """ str: The name of this model based on the plugin name. Overridden as DFL-SAE is
        named differently depending on the architecture selected. """
        basename = super().name
        name = f"{basename}_{self.architecture}"
        return name

    @property
    def ae_dims(self):
        """ Set the Autoencoder Dimensions or set to default """
        retval = self.config["autoencoder_dims"]
        if retval == 0:
            retval = 256 if self.architecture == "liae" else 512
        return retval

    def _patch_weights_management(self, arguments):
        """ Patch in the correct encoder name into the config dictionary for freezing and loading
        weights based on architecture.

        Because of variable model name based on architecture, configfile needs to be loaded
        prior to initializing parent

        Parameters
        ----------
        arguments: :class:`argparse.Namespace`
            The arguments that were passed to the train or convert process as generated from
            Faceswap's command line arguments

        """
        self._configfile = arguments.configfile if hasattr(arguments, "configfile") else None
        self.architecture = self.config["architecture"].lower()
        self.config["freeze_layers"] = [f"encoder_{self.architecture}"]
        self.config["load_layers"] = [f"encoder_{self.architecture}"]
        logger.debug("Patched encoder layers to config: %s", self.config)

    def build_model(self, inputs):
        """ Build the DFL-SAE Model """
        encoder = getattr(self, "encoder_{}".format(self.architecture))()
        enc_output_shape = encoder.output_shape[1:]
        encoder_a = encoder(inputs[0])
        encoder_b = encoder(inputs[1])

        if self.architecture == "liae":
            inter_both = self.inter_liae("both", enc_output_shape)
            int_output_shape = (np.array(inter_both.output_shape[1:]) * (1, 1, 2)).tolist()

            inter_a = Concatenate()([inter_both(encoder_a), inter_both(encoder_a)])
            inter_b = Concatenate()([self.inter_liae("b", enc_output_shape)(encoder_b),
                                     inter_both(encoder_b)])

            decoder = self.decoder("both", int_output_shape)
            outputs = [decoder(inter_a), decoder(inter_b)]
        else:
            outputs = [self.decoder("a", enc_output_shape)(encoder_a),
                       self.decoder("b", enc_output_shape)(encoder_b)]
        autoencoder = KerasModel(inputs,
                                 outputs,
                                 name=self.name)
        return autoencoder

    def encoder_df(self):
        """ DFL SAE DF Encoder Network"""
        input_ = Input(shape=self.input_shape)
        dims = self.input_shape[-1] * self.encoder_dim
        lowest_dense_res = self.input_shape[0] // 16
        var_x = Conv2DBlock(dims, activation="leakyrelu")(input_)
        var_x = Conv2DBlock(dims * 2, activation="leakyrelu")(var_x)
        var_x = Conv2DBlock(dims * 4, activation="leakyrelu")(var_x)
        var_x = Conv2DBlock(dims * 8, activation="leakyrelu")(var_x)
        var_x = Dense(self.ae_dims)(Flatten()(var_x))
        var_x = Dense(lowest_dense_res * lowest_dense_res * self.ae_dims)(var_x)
        var_x = Reshape((lowest_dense_res, lowest_dense_res, self.ae_dims))(var_x)
        var_x = UpscaleBlock(self.ae_dims, activation="leakyrelu")(var_x)
        return KerasModel(input_, var_x, name="encoder_df")

    def encoder_liae(self):
        """ DFL SAE LIAE Encoder Network """
        input_ = Input(shape=self.input_shape)
        dims = self.input_shape[-1] * self.encoder_dim
        var_x = Conv2DBlock(dims, activation="leakyrelu")(input_)
        var_x = Conv2DBlock(dims * 2, activation="leakyrelu")(var_x)
        var_x = Conv2DBlock(dims * 4, activation="leakyrelu")(var_x)
        var_x = Conv2DBlock(dims * 8, activation="leakyrelu")(var_x)
        var_x = Flatten()(var_x)
        return KerasModel(input_, var_x, name="encoder_liae")

    def inter_liae(self, side, input_shape):
        """ DFL SAE LIAE Intermediate Network """
        input_ = Input(shape=input_shape)
        lowest_dense_res = self.input_shape[0] // 16
        var_x = input_
        var_x = Dense(self.ae_dims)(var_x)
        var_x = Dense(lowest_dense_res * lowest_dense_res * self.ae_dims * 2)(var_x)
        var_x = Reshape((lowest_dense_res, lowest_dense_res, self.ae_dims * 2))(var_x)
        var_x = UpscaleBlock(self.ae_dims * 2, activation="leakyrelu")(var_x)
        return KerasModel(input_, var_x, name="intermediate_{}".format(side))

    def decoder(self, side, input_shape):
        """ DFL SAE Decoder Network"""
        input_ = Input(shape=input_shape)
        outputs = []

        dims = self.input_shape[-1] * self.decoder_dim
        var_x = input_

        var_x1 = UpscaleBlock(dims * 8, activation=None)(var_x)
        var_x1 = LeakyReLU(alpha=0.2)(var_x1)
        var_x1 = ResidualBlock(dims * 8)(var_x1)
        var_x1 = ResidualBlock(dims * 8)(var_x1)
        if self.multiscale_count >= 3:
            outputs.append(Conv2DOutput(3, 5, name="face_out_32_{}".format(side))(var_x1))

        var_x2 = UpscaleBlock(dims * 4, activation=None)(var_x1)
        var_x2 = LeakyReLU(alpha=0.2)(var_x2)
        var_x2 = ResidualBlock(dims * 4)(var_x2)
        var_x2 = ResidualBlock(dims * 4)(var_x2)
        if self.multiscale_count >= 2:
            outputs.append(Conv2DOutput(3, 5, name="face_out_64_{}".format(side))(var_x2))

        var_x3 = UpscaleBlock(dims * 2, activation=None)(var_x2)
        var_x3 = LeakyReLU(alpha=0.2)(var_x3)
        var_x3 = ResidualBlock(dims * 2)(var_x3)
        var_x3 = ResidualBlock(dims * 2)(var_x3)

        outputs.append(Conv2DOutput(3, 5, name="face_out_128_{}".format(side))(var_x3))

        if self.use_mask:
            var_y = input_
            var_y = UpscaleBlock(self.decoder_dim * 8, activation="leakyrelu")(var_y)
            var_y = UpscaleBlock(self.decoder_dim * 4, activation="leakyrelu")(var_y)
            var_y = UpscaleBlock(self.decoder_dim * 2, activation="leakyrelu")(var_y)
            var_y = Conv2DOutput(1, 5, name="mask_out_{}".format(side))(var_y)
            outputs.append(var_y)
        return KerasModel(input_, outputs=outputs, name="decoder_{}".format(side))

    def _legacy_mapping(self):
        """ The mapping of legacy separate model names to single model names """
        name = "dfl_sae"
        mappings = dict(df={"{}_encoder.h5".format(name): "encoder_df",
                            "{}_decoder_A.h5".format(name): "decoder_a",
                            "{}_decoder_B.h5".format(name): "decoder_b"},
                        liae={"{}_encoder.h5".format(name): "encoder_liae",
                              "{}_intermediate_B.h5".format(name): "intermediate_both",
                              "{}_intermediate.h5".format(name): "intermediate_b",
                              "{}_decoder.h5".format(name): "decoder_both"})
        return mappings[self.config["architecture"]]
