//
//  ViewController.swift
//  HospitalMap
//
//  Created by KPU_GAME on 2020/05/18.
//  Copyright © 2020 KPU_GAME. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameInsert: UITextField!
    @IBOutlet weak var transcribeButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var myTextView: UITextView!
    
    // 음성인식 객체
    // 실시간으로 말하기 기능을 구현하려면 앱에서 SFSpeechRecognizer, SFSpeechAudioBufferRecognitionRequest
    // 및 SFSpeechRecognitionTask 클래스의 인스턴스가 필요합니다.
    // 영어, 한글 모두 인식하고 싶다면
    //private let speechRecognizer = SFSpeechRecognizer()!
    // 영어만 인식하고 싶다면
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    
    private var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    // AVAudioEngine 인스턴스를 사용하여 오디오를 오디오 버퍼로 스트리밍
    private let audioEngine = AVAudioEngine()
    
    @IBAction func startTranscribing(_ sender: Any) {
        transcribeButton.isEnabled = false
        stopButton.isEnabled = true
        try! startSession()
    }
    @IBAction func stopTranscribing(_ sender: Any) {
        // 오디오 엔진을 중지하고 다음 세션에 사용할 준비가 된 버튼의 상태를 구성
        if audioEngine.isRunning {
            audioEngine.stop()
            speechRecognitionRequest?.endAudio()
            transcribeButton.isEnabled = true
            stopButton.isEnabled = false
        }
        
        // 음성인식한 내용을 TextField에 반영
        self.nameInsert.text = myTextView.text
        sggNm = myTextView.text
    }
    // Done 버튼을 누르면 동작하는 unwind 메소드
    @IBAction func doneToPickerViewController(segue:UIStoryboardSegue) {
        
    }
    
    // 도시 공원 정보 OpenAPI 및 인증키

    var url : String = "https://openapi.gg.go.kr/CityPark?KEY=3e0fa34593e7461f8cfce44931d9bea0&SIGUN_NM="
    var sggNm : String = " "
    var sggNm_utf8 : String = " "
    
    // prepare 메소드는 segue 실행될 때 호출되는 메소드
    // id를 segueToTableView로 설정
    // HospitalTableViewController에 url 정보 전달하기 위해서 먼저 UINavigationController를
    // destination으로 설정한 후 HospitalViewController를 선택함
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToTableView" {
            sggNm = nameInsert.text!
            sggNm_utf8 = sggNm.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            if let navController = segue.destination as? UINavigationController {
                if let hospitalTableViewController = navController.topViewController as? HospitalTableViewController {
                    hospitalTableViewController.url = url + sggNm_utf8
                    hospitalTableViewController.ssg = sggNm_utf8
                }
            }
        }
    }
    
    // 음성 인식을 수행하는 메소드 호출은 예외를 throw 할 가능성 있음
    func startSession() throws {
        // startSession 메서드 내에서 수행되는 첫 번재 작업은 이전 인식 작업이 실행 중인지 확인하고, 그렇지 않으면 작업을 취소하는 것입니다.
        if let recognitionTask = speechRecognitionTask {
            recognitionTask.cancel()
            self.speechRecognitionTask = nil
        }
        // 또한 이 메서드는 오디오 녹음 세션을 구성
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.record)
        
        // 이전에 선언된 speechRecognitionRequest 변수에 SFSpeechAudioBufferRecognitionRequest 개체를 할당해야합니다.
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // 그런 다음 SFSpeechAudioBufferRecognitionRequest 개체가 성공적으로 만들어 졌는지 확인하기 위한 테스트가 수행됩니다.
        // 생성이 실패한 경우 예외가 throw 됩니다.
        // guard let - 이것이 nil이 아니라면 뭔가를 수행하는 것이고 nil이면 else가 호출된다
        guard let recognitionRequest = speechRecognitionRequest else { fatalError("SFSpeechAudioBufferRecognitionRequest object creation failed") }
        
        // 오디오 엔진의 inputNode에 대한 참졸르 가져 와서 상수에 할당해야합니다
        // 입력 노드를 사용할 수 없는 경우 치명적인 오류가 발생합니다
        let inputNode = audioEngine.inputNode //else { fatalError("Audio engine has no input node") }
        
        // recognitionRequest 인스턴스는 부분 결과를 반환하도록 구성되므로 음성 오디오가 버퍼에 도착할 때 계속해서 녹음을 수행 할 수 있습니다.
        // 이 속성이 설정되지 않은 경우 앱은 녹음 과정을 시작하기 전에 오디오 세션이 끝날 때까지 대기합니다.
        recognitionRequest.shouldReportPartialResults = true
        
        // 인식 잡업이 초기화됩니다.
        // 인식 요청 객체로 초기화 된 인식 태스크를 생성합니다.
        // 클로저는 완성 된 텍스트의 각 블록이 완료 될 때 반복적으로 호출되는 완료 핸들러로 지정됩니다.
        // 처리기가 호출 될 때마다 오류 개체와 함께 최신 버전의 텍스트가 포함 된 결과 개체가 전달됩니다.
        speechRecognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in

            var finished = false
            // 결과 객체의 isFinal 속성이 false (라이브 오디오가 여전히 버퍼로 스트리밍됨을 나타냄) 오류가 발생하지 않는 한 텍스트는 텍스트보기에 표시됩니다.
            if let result = result {
                self.myTextView.text =
                result.bestTranscription.formattedString
                finished = result.isFinal
            }
            // 그렇지 않으면 오디오 엔진이 중지되고 탭이 오디오 노드에서 제거되고 인식 요청 및 인식 작업 객체가 nil로 설정됩니다.
            // 기록 단추는 다음 세션 준비를 위해 사용할 수도 있습니다.
            if error != nil || finished {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil

                self.transcribeButton.isEnabled = true
            }
        }
        // 인식 작업을 구성하고 나면 이 단계에서 남은 것은 오디오 엔진의 입력 노드에 탭을 설치한 다음 실행중인 엔진을 시작하는 것입니다.
        // inputNode 객체의 installTap 메서드는 클로저를 완료 핸들러로 사용합니다
        // 이 핸들러의 코드는 호출 될 때마다 최신 오디오 버퍼를 speechRecognitionRequest 객체에 추가하기 만하면 자동으로 녹음되고
        // 텍스트 인식 뷰에 표시되는 음성 인식 작업의 완료 핸들러로 전달됩니다.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in

            self.speechRecognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func authorizeSR() {
        // 완료 핸들러로 지정된 클로저를 사용하여 SFSpeechRecognizer클래스의 requestAuthorizeation 메소드를 호출합니다
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // 이 핸들러에는 4 개의 값 (권한 부여, 거부, 제한 또는 결정되지 않음) 중 하나 일 수 있는 상태 값이 전달됩니다.
            // 그런 다음 switch 문을 사용하여 상태를 평가하고 기록 버튼을 활성화하거나 해당 버튼에 실패 원인을 표시합니다.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.transcribeButton.isEnabled = true
                    
                case .denied:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition access denied by user", for: .disabled)
                    
                case .restricted:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition access on device", for: .disabled)
                    
                case .notDetermined:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition not authorized", for: .disabled)
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameInsert.delegate = self
        // Do any additional setup after loading the view.
    }


}

