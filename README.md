# SwiftUI - Speech-to-Text

Simply when you tap the button the recording sequence starts, when audio is taken it sends it to the apple servers to be transcribed and then when you tap to stop recording it gives you the best possible text.

Someone from my youtube channel asked for me to make this, i looked online and only one person has created a speech to text with swiftUI but it was a little confusing. So i went and made my own version. This readme explains the class and the variables in it, i will also provide links to apple documentation because they explain it better than i would. For more information visit my Youtube Video....



I tried to keep this simple.


I have 5 files in this project:


AppDelegate - Controls App

SceneDelegate - Controls Scene

ContentView - Main View

SwiftUI Speech - Class

SpeechButton - Button View


SwiftUI Speech Class:


Variables:


bool isRecording - keep track of record and stop record

var button - Button view

let speechRecognizer - https://developer.apple.com/documentation/speech/sfspeechrecognizer

let recognitionRequest - https://developer.apple.com/documentation/speech/sfspeechaudiobufferrecognitionrequest

let authStat - https://developer.apple.com/documentation/speech/sfspeechrecognizer

let recognitionTask - https://developer.apple.com/documentation/speech/sfspeechrecognitiontask

let audioEngine - https://developer.apple.com/documentation/avfoundation/avaudioengine

var outputText - String to hold output



Functions:

getButton -> SpeechButton - Returns the button view

startRecording -> Void - starts the recording sequence

stopRecording -> Void - stops the recording sequence

getSpeechStatus -> String - gets the auth results of using the mic


-End.
