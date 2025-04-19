//
//  ViewController.swift
//  Integrity
//
//  Created by ldcc on 2023/05/11.
//

import UIKit
import CommonCrypto


class ViewController: UIViewController {
    @IBOutlet weak var textCurrent: UILabel!
    @IBOutlet weak var textOriginal: UILabel!
    @IBOutlet weak var textResult: UILabel!
    
    @IBAction func jailbreakAction(_ sender: Any) {
        if isJailbroken() {
            textResult.text = "Device is jailbroken.";
        }
        else {
            textResult.text = "Device is not jailbroken.";
        }
    }
    @IBAction func integrityAction(_ sender: Any) {
        if verifyIntegrity() {
            textResult.text = "App integrity check succeeded.";
        }
        else {
            textResult.text = "App integrity check failed.";
        }
    }
    @IBAction func DebuggingAction(_ sender: Any) {
        if isDebuggerAttached() {
            textResult.text = "Debugger detected.";
        }
        else {
            textResult.text = "Debugger not detected.";
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textOriginal.text = "[Original Hash]\n45aac298ed374d8721e923ebe5c9b300cb18b5507036aba1bfd76c3c4833d1da"
        textCurrent.text = "[Current Hash]\n\n\n";
    }
    
    func isJailbroken() -> Bool {
        // 시뮬레이터인 인지 확인
        #if targetEnvironment(simulator)
        return false
        #else
        
        // 탈옥된 장치에서 일반적으로 발견되는 파일이나 디렉토리 확인
        let fileManager = FileManager.default
        let jailbreakFilePaths = ["/Applications/Cydia.app",
                                  "/Library/MobileSubstrate/MobileSubstrate.dylib",
                                  "/bin/bash",
                                  "/usr/sbin/sshd",
                                  "/etc/apt",
                                  "/usr/bin/ssh",
                                  "/private/var/lib/apt"]
        for path in jailbreakFilePaths {
            if fileManager.fileExists(atPath: path) {
                return true
            }
        }
        
        // 탈옥된 환경에서만 접근 가능한 cydia 접근 시도
        let cydiaUrlScheme = URL(string: "cydia://package/com.example.package")
        if UIApplication.shared.canOpenURL(cydiaUrlScheme!) {
            return true
        }
        
        // 테스트 파일을 개인 디렉토리에 쓴 다음 즉시 삭제하려고 시도
        let path = "/private/" + UUID().uuidString
        do {
            try "test".write(toFile: path, atomically: true, encoding: .utf8)
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
        
        // 앱이 다른 프로세스에 의해 디버깅되거나 추적되고 있는지 확인
        var name: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var info = kinfo_proc()
        var info_size = MemoryLayout<kinfo_proc>.stride
        sysctl(&name, UInt32(name.count), &info, &info_size, nil, 0)
        let flags = info.kp_proc.p_flag
        if flags & P_TRACED != 0 {
            return true
        }
        
        // 쓰기 전용 디렉토리에서 읽기 모드에서 파일을 열 수 있는지 확인
        var file = fopen("/bin/bash", "r")
        if file != nil {
            fclose(file)
            return true
        }
        
        return false
        #endif
    }
    
    // 번들에 있는 파일 중 앱 바이너리 파일의 해시값을 비교하여 무결성 검증
    func verifyIntegrity() -> Bool {
        let mainBundle = Bundle.main
        let bundlePath = mainBundle.bundlePath
        let filesEnumerator = FileManager.default.enumerator(atPath: bundlePath)!
        while let file = filesEnumerator.nextObject() as? String {
            let filePath = "\(bundlePath)/\(file)"
            if FileManager.default.fileExists(atPath: filePath) {
                if let data = FileManager.default.contents(atPath: filePath) {
                    let hash = sha256(data: data)
                    if file == "Integrity" {
                        textCurrent.text = "[Current Hash]\n" + hash;
                        if hash == "45aac298ed374d8721e923ebe5c9b300cb18b5507036aba1bfd76c3c4833d1da" {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }

    func sha256(data: Data) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    // sysctl() 함수를 통해 현재 프로세스에 대한 정보를 검색 하고 attach를 했다면 P_TRACED 플래그가 설정
    func isDebuggerAttached() -> Bool {
        var info = kinfo_proc()
        var mib : [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout.stride(ofValue: info)
        let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
}
