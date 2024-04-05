��             +         �    �  �   �  �   �  1  )  �   [  �   �  D  �  ?  �  �   
  C    C  V  �   �  b  �  2  �  c         s   �  6   �  3   1  �   e  �   !  r  �    P  �   g  c        j     w     }     �  	   �     �  Z  �  O  �  �   I   �   (!  O  �!  �   #  �   �#  �  �$  \  &    v'  [  �(  [  �)  �   N+  �  ?,  �  �.  S  g1     �6  �   �6  C   W7  P   �7  �   �7  �   �8  �  �9  O  �;  �   �<  r   �=     >     >     >      >  	   2>     <>                                                                                                         
                             	          Batch size. This is the number of images processed through the model for each side per iteration. NB: As the model is fed 2 sides at a time, the actual number of images within the model at any one time is double the number that you set here. Larger batches require more GPU RAM. Color augmentation helps make the model less susceptible to color differences between the A and B sets, at an increased training time cost. Enable this option to disable color augmentation. Disables TensorBoard logging. NB: Disabling logs means that you will not be able to use the graph or analysis for this session in the GUI. Freeze the weights of the model. Freezing weights means that some of the parameters in the model will no longer continue to learn, but those that are not frozen will continue to learn. For most models, this will freeze the encoder, but some models may have configuration options for freezing other layers. Input directory. A directory containing training images for face A. This is the original face, i.e. the face that you want to remove and replace with face B. Input directory. A directory containing training images for face B. This is the swap face, i.e. the face that you want to place onto the head of person A. Length of training in iterations. This is only really used for automation. There is no 'correct' number of iterations a model should be trained for. You should stop training when you are happy with the previews. However, if you want the model to stop automatically at a set number of iterations, you can set that value here. Model directory. This is where the training data will be stored. You should always specify a new folder for new models. If starting a new model, select either an empty folder, or a folder which does not exist (which will be created). If continuing to train an existing model, specify the location of the existing model. Optional for creating a timelapse. Timelapse will save an image of your selected faces into the timelapse-output folder at every save iteration. If the input folders are supplied but no output folder, it will default to your model folder/timelapse/ Optional for creating a timelapse. Timelapse will save an image of your selected faces into the timelapse-output folder at every save iteration. This should be the input folder of 'A' faces that you would like to use for creating the timelapse. You must also supply a --timelapse-output and a --timelapse-input-B parameter. Optional for creating a timelapse. Timelapse will save an image of your selected faces into the timelapse-output folder at every save iteration. This should be the input folder of 'B' faces that you would like to use for creating the timelapse. You must also supply a --timelapse-output and a --timelapse-input-A parameter. Output a summary of the model and exit. If a model folder is provided then a summary of the saved model is displayed. Otherwise a summary of the model that would be created by the chosen plugin and configuration settings is displayed. R|Load the weights from a pre-existing model into a newly created model. For most models this will load weights from the Encoder of the given model into the encoder of the newly created model. Some plugins may have specific configuration options allowing you to load weights from other layers. Weights will only be loaded when creating a new model. This option will be ignored if you are resuming an existing model. Generally you will also want to 'freeze-weights' whilst the rest of your model catches up with your Encoder.
NB: Weights can only be loaded from models of the same plugin as you intend to train. R|Select the distribution stategy to use.
L|default: Use Tensorflow's default distribution strategy.
L|central-storage: Centralizes variables on the CPU whilst operations are performed on 1 or more local GPUs. This can help save some VRAM at the cost of some speed by not storing variables on the GPU. Note: Mixed-Precision is not supported on multi-GPU setups.
L|mirrored: Supports synchronous distributed training across multiple local GPUs. A copy of the model and all variables are loaded onto each GPU with batches distributed to each GPU at each iteration. R|Select which trainer to use. Trainers can be configured from the Settings menu or the config folder.
L|original: The original model created by /u/deepfakes.
L|dfaker: 64px in/128px out model from dfaker. Enable 'warp-to-landmarks' for full dfaker method.
L|dfl-h128: 128px in/out model from deepfacelab
L|dfl-sae: Adaptable model from deepfacelab
L|dlight: A lightweight, high resolution DFaker variant.
L|iae: A model that uses intermediate layers to try to get better details
L|lightweight: A lightweight model for low-end cards. Don't expect great results. Can train as low as 1.6GB with batch size 8.
L|realface: A high detail, dual density model based on DFaker, with customizable in/out resolution. The autoencoders are unbalanced so B>A swaps won't work so well. By andenixa et al. Very configurable.
L|unbalanced: 128px in/out model from andenixa. The autoencoders are unbalanced so B>A swaps won't work so well. Very configurable.
L|villain: 128px in/out model from villainguy. Very resource hungry (You will require a GPU with a fair amount of VRAM). Good for details, but more susceptible to color differences. Saving Sets the number of iterations before saving a backup snapshot of the model in it's current state. Set to 0 for off. Sets the number of iterations between each model save. Show training preview output. in a separate window. To effectively learn, a random set of images are flipped horizontally. Sometimes it is desirable for this not to occur. Generally this should be left off except for during 'fit training'. Train a model on extracted original (A) and swap (B) faces.
Training models can take a long time. Anything from 24hrs to over a week
Model plugins can be configured in the 'Settings' Menu Use the Learning Rate Finder to discover the optimal learning rate for training. For new models, this will calculate the optimal learning rate for the model. For existing models this will use the optimal learning rate that was discovered when initializing the model. Setting this option will ignore the manually configured learning rate (configurable in train settings). Warping is integral to training the Neural Network. This option should only be enabled towards the very end of training to try to bring out more detail. Think of it as 'fine-tuning'. Enabling this option from the beginning is likely to kill a model and lead to terrible results. Warps training faces to closely matched Landmarks from the opposite face-set rather than randomly warping the face. This is the 'dfaker' way of doing warping. Writes the training result to a file. The image will be stored in the root of your FaceSwap folder. augmentation faces model preview timelapse training Project-Id-Version: faceswap.spanish
Report-Msgid-Bugs-To: 
PO-Revision-Date: 2024-03-28 18:09+0000
Last-Translator: 
Language-Team: tokafondo
Language: es
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n != 1);
Generated-By: pygettext.py 1.5
X-Generator: Poedit 3.4.2
 Tamaño del lote. Este es el número de imágenes procesadas a través del modelo para cada lado por iteración. Nota: Como el modelo se alimenta de 2 lados a la vez, el número real de imágenes dentro del modelo en cualquier momento es el doble del número que se establece aquí. Los lotes más grandes requieren más RAM de la GPU. El aumento del color ayuda a que el modelo sea menos susceptible a las diferencias de color entre los conjuntos A y B, con un mayor coste de tiempo de entrenamiento. Activa esta opción para desactivar el aumento de color. Desactiva el registro de TensorBoard. NB: Desactivar los registros significa que no podrá utilizar el gráfico o el análisis de esta sesión en la GUI. Congele los pesos del modelo. Congelar pesos significa que algunos de los parámetros del modelo ya no seguirán aprendiendo, pero los que no están congelados seguirán aprendiendo. Para la mayoría de los modelos, esto congelará el codificador, pero algunos modelos pueden tener opciones de configuración para congelar otras capas. Directorio de entrada. Un directorio que contiene imágenes de entrenamiento para la cara A. Esta es la cara original, es decir, la cara que se quiere eliminar y sustituir por la cara B. Directorio de entrada. Un directorio que contiene imágenes de entrenamiento para la cara B. Esta es la cara de intercambio, es decir, la cara que se quiere colocar en la cabeza de la persona A. Duración del entrenamiento en iteraciones. Esto sólo se utiliza realmente para la automatización. No hay un número 'correcto' de iteraciones para las que deba entrenarse un modelo. Debe dejar de entrenar cuando esté satisfecho con las previsiones. Sin embargo, si desea que el modelo se detenga automáticamente en un número determinado de iteraciones, puede establecer ese valor aquí. Directorio del modelo. Aquí es donde se almacenarán los datos de entrenamiento. Siempre debe especificar una nueva carpeta para los nuevos modelos. Si se inicia un nuevo modelo, seleccione una carpeta vacía o una carpeta que no exista (que se creará). Si continúa entrenando un modelo existente, especifique la ubicación del modelo existente. Opcional para crear un timelapse. Timelapse guardará una imagen de las caras seleccionadas en la carpeta timelapse-output en cada iteración de guardado. Si se suministran las carpetas de entrada pero no la carpeta de salida, se guardará por defecto en la carpeta del modelo/timelapse/ Opcional para crear un timelapse. Timelapse guardará una imagen de las caras seleccionadas en la carpeta timelapse-output en cada iteración de guardado. Esta debe ser la carpeta de entrada de las caras "A" que desea utilizar para crear el timelapse. También debe suministrar un parámetro --timelapse-output y un parámetro --timelapse-input-B. Opcional para crear un timelapse. Timelapse guardará una imagen de las caras seleccionadas en la carpeta timelapse-output en cada iteración de guardado. Esta debe ser la carpeta de entrada de las caras "B" que desea utilizar para crear el timelapse. También debe suministrar un parámetro --timelapse-output y un parámetro --timelapse-input-A. Genere un resumen del modelo y salga. Si se proporciona una carpeta de modelo, se muestra un resumen del modelo guardado. De lo contrario, se muestra un resumen del modelo que crearía el complemento elegido y los ajustes de configuración. R|Cargue los pesos de un modelo preexistente en un modelo recién creado. Para la mayoría de los modelos, esto cargará pesos del codificador del modelo dado en el codificador del modelo recién creado. Algunos complementos pueden tener opciones de configuración específicas que le permiten cargar pesos de otras capas. Los pesos solo se cargarán al crear un nuevo modelo. Esta opción se ignorará si está reanudando un modelo existente. En general, también querrá 'congelar pesos' mientras el resto de su modelo se pone al día con su codificador.
NB: Los pesos solo se pueden cargar desde modelos del mismo complemento que desea entrenar. 562 / 5,000
Translation results
R|Seleccione la estrategia de distribución a utilizar.
L|default: utiliza la estrategia de distribución predeterminada de Tensorflow.
L|central-storage: centraliza las variables en la CPU mientras que las operaciones se realizan en 1 o más GPU locales. Esto puede ayudar a ahorrar algo de VRAM a costa de cierta velocidad al no almacenar variables en la GPU. Nota: Mixed-Precision no es compatible con configuraciones de múltiples GPU.
L|mirrored: Admite el entrenamiento distribuido síncrono en varias GPU locales. Se carga una copia del modelo y todas las variables en cada GPU con lotes distribuidos a cada GPU en cada iteración. R|Seleccione el entrenador que desea utilizar. Los entrenadores se pueden configurar desde el menú de configuración o la carpeta de configuración.
L|original: El modelo original creado por /u/deepfakes.
L|dfaker: Modelo de 64px in/128px out de dfaker. Habilitar 'warp-to-landmarks' para el método completo de dfaker.
L|dfl-h128: modelo de 128px in/out de deepfacelab
L|dfl-sae: Modelo adaptable de deepfacelab
L|dlight: Una variante de DFaker ligera y de alta resolución.
L|iae: Un modelo que utiliza capas intermedias para tratar de obtener mejores detalles.
L|lightweight: Un modelo ligero para tarjetas de gama baja. No esperes grandes resultados. Puede entrenar hasta 1,6GB con tamaño de lote 8.
L|realface: Un modelo de alto detalle y doble densidad basado en DFaker, con resolución de entrada y salida personalizable. Los autocodificadores están desequilibrados, por lo que los intercambios B>A no funcionan tan bien. Por andenixa et al. Muy configurable
L|Unbalanced: modelo de 128px de entrada/salida de andenixa. Los autocodificadores están desequilibrados por lo que los intercambios B>A no funcionarán tan bien. Muy configurable
L|villain: Modelo de 128px de entrada/salida de villainguy. Requiere muchos recursos (se necesita una GPU con una buena cantidad de VRAM). Bueno para los detalles, pero más susceptible a las diferencias de color. Guardar Establece el número de iteraciones antes de guardar una copia de seguridad del modelo en su estado actual. Establece 0 para que esté desactivado. Establece el número de iteraciones entre cada guardado del modelo. Mostrar la salida de la vista previa del entrenamiento. en una ventana separada. Para aprender de forma efectiva, se voltea horizontalmente un conjunto aleatorio de imágenes. A veces es deseable que esto no ocurra. Por lo general, esto debería dejarse sin efecto, excepto durante el 'entrenamiento de ajuste'. Entrene un modelo con las caras originales (A) e intercambiadas (B) extraídas.
El entrenamiento de los modelos puede llevar mucho tiempo. Desde 24 horas hasta más de una semana.
Los plugins de los modelos pueden configurarse en el menú "Ajustes" Utilice el Buscador de tasa de aprendizaje para descubrir la tasa de aprendizaje óptima para la capacitación. Para modelos nuevos, esto calculará la tasa de aprendizaje óptima para el modelo. Para los modelos existentes, esto utilizará la tasa de aprendizaje óptima que se descubrió al inicializar el modelo. Configurar esta opción ignorará la tasa de aprendizaje configurada manualmente (configurable en la configuración del tren). La deformación es fundamental para el entrenamiento de la red neuronal. Esta opción sólo debería activarse hacia el final del entrenamiento para tratar de obtener más detalles. Piense en ello como un 'ajuste fino'. Si se activa esta opción desde el principio, es probable que arruine el modelo y se obtengan resultados terribles. Deforma las caras de entrenamiento a puntos de referencia muy parecidos del conjunto de caras opuestas en lugar de deformar la cara al azar. Esta es la forma 'dfaker' de hacer la deformación. Escribe el resultado del entrenamiento en un archivo. La imagen se almacenará en la raíz de su carpeta FaceSwap. aumento caras modelo previsualización intervalo entrenamiento 