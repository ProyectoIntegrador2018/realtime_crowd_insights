# Realtime Crowd Insights

## Do's and Don'ts
### Información general del Proyecto
* Es una aplicación desarrollada para dispositivos iOS (iPhone especificamente) con el propósito de obtener características de personas en imágenes/video utilizando el API de Azure.
* Actualmente solo funciona con imágenes.
* La funcionalidad de tomar una fotografía solo funciona con un iPhone (no funciona con el simulador.) El iPhone debe contar con iOS13+.

### Información del desarrollo
* Fue desarrollada usando Xcode 11.0. Justo en esta versión hubo un cambio en donde dejaron de existir los Storyboards y Apple lanzó algo llamado [SwiftUI](https://developer.apple.com/xcode/swiftui/) que sirve para hacer las interfaces de las aplicaciones. Sin embargo, al crear un proyecto nuevo, Xcode permite seleccionar la opción de Storyboards.
![Storyboards](https://i.ibb.co/1bwV0ST/Screen-Shot-2019-12-02-at-11-46-41-PM.png)
Este proyecto comenzó a desarrollarse con SwiftUI pero debido a que era algo desconocido para el equipo de desarrollo, se decidió migrar el proyecto a utilizar Storyboards. Lo ideal sería trabajar con SwiftUI pues las aplicaciones nuevas ya serán desarrolladas con esto. Sin embargo, el equipo no contaba con mucho tiempo para aprender a utilizarlo.
* Para utilizar los servicios de Azure, se necesita una cuenta. La de alumno del Tec de Monterrey sirve, sin embargo, el proyecto está desarrollado utilizando una cuenta de Blue People. Se solicita poner los datos de una tarjeta pero no se harán cobros, pues se cuenta con ciertos créditos para utilizar los servicios gratuitamente.
* Microsoft ofrece documentación acerca del uso de sus servicios, sin embargo, para hacer la conexión a Swift existe poca. [Esta liga](https://westus.dev.cognitive.microsoft.com/docs/services/563879b61984550e40cbbe8d/operations/563879b61984550f30395236) contiene información útil sobre los parámetros que debe llevar cada llamada y lo que regresa.
* Existen dos tutoriales que el equipo de desarrollo estudió antes de desarrollar la aplicación:
	* [Facial recognition on iOS using Microsoft Azure Face API](https://medium.com/@alejandrocotilla/facial-recognition-on-ios-using-microsoft-azure-face-api-9a38eac5d0f2)
	* [Microsoft Face API: iOS Client Library & Sample](https://github.com/microsoft/Cognitive-Face-iOS)
El proyecto se parece más al primer tutorial, pues el segundo utiliza Cocoapods que no fueron utilizados por el equipo.

### Do's
* Experimenten con el API de Azure antes de entrar al proyecto. Creen una aplicación prototipo para entender cómo funciona y cómo se deben hacer las llamadas y qué regresan.
* Experimenten con SwiftUI antes de empezar el proyecto. Lean la documentación y realicen una aplicación utilizando esto.
* Code Climate podrá marcar "error" en algunas funciones. Revisen bien cada archivo. Puede ser que marque error en alguna función por ser muy compleja pero es la función que hace las peticiones al servicio de Azure, y así debe ser. Para excluir archivos de Code Climate, se pueden agregar al archivo .codeclimate.yml.
	* Actualmente se están excluyendo los archivos SwiftyJSON que corresponden a los Pods instalados para poder leer JSON en Swift debido a que no es código escrito por el equipo. (La respuesta de Azure está en formato JSON).
* Si aparece un error de "Cannot connect to Azure", esperen un momento antes de mandar peticiones (mandar imágenes). A veces tarda en recibir la información.

### Don'ts
* No sigan tutoriales sin entender lo que sucede, pues muchas veces los tutoriales no hacen 100% lo que se necesita para la aplicación, y sin entender, será muy difícil adaptar el contenido a lo deseado.