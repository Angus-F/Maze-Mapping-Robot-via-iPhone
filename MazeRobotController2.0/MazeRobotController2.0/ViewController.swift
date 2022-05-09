//
//  ViewController.swift
//  MazeRobotController2.0
//
//  Created by Angus Young on 2022/2/1.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {

    @IBOutlet var Forward_Button: UIButton!
    @IBOutlet var Backward_Button: UIButton!
    @IBOutlet var Left_Button: UIButton!
    @IBOutlet var Right_Button: UIButton!
    @IBOutlet var Mode_Switch: UISwitch!
    @IBOutlet var Mode_Label: UILabel!
    @IBOutlet var Connected: UIImageView!
    @IBOutlet var Disconnected: UIImageView!
    @IBOutlet var PathView: UIImageView!
    @IBOutlet var RightData: UILabel!
    @IBOutlet var FrontData: UILabel!
    @IBOutlet var LeftData: UILabel!
    
    
    @IBAction func Mode_Change(_ sender: UISwitch) {
        if (Mode_Switch.isOn) {
            Mode_Label.text = "Autonomous"
            writeValue(characteristic: ModeSwitchCharacteristic, value: 1)
        } else {
            Mode_Label.text = "Manual"
            writeValue(characteristic: ModeSwitchCharacteristic, value: 0)
        }
    }
    @IBAction func ConnectWithRobot(_ sender: UIButton) {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    @IBAction func DisconnectWithRobot(_ sender: UIButton) {
        centralManager = nil
        print("Disconnect")
        if (Disconnected.isHidden) {
            Disconnected.isHidden = false
            Connected.isHidden = true
        }
    }
    @IBAction func ResetRobot(_ sender: UIButton) {
        initView()
    }
    @IBAction func StartDraw(_ sender: UIButton) {
        DrawWallFlag = true
    }
    @IBAction func DemoView(_ sender: UIButton) {
        let demoimage1 = ViewRenderer.image {ctx in
            outlineImage.draw(at: .zero)
            robotImage.draw(at: CGPoint(x: 310, y: 310))
        }
        let demoimage2 = ViewRenderer.image {ctx in
            outlineImage.draw(at: .zero)
            robotImage.draw(at: CGPoint(x: 310, y: 310))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 285))
        }
        let demoimage3 = ViewRenderer.image {ctx in
            outlineImage.draw(at: .zero)
            robotImage.draw(at: CGPoint(x: 310, y: 240))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 285))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 215))
        }
        let demoimage4 = ViewRenderer.image {ctx in
            outlineImage.draw(at: .zero)
            robotImage.draw(at: CGPoint(x: 310, y: 170))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 285))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 215))
            HorizontalLineImage.draw(at: CGPoint(x: 285, y: 145))
            
        }
        let demoimage5 = ViewRenderer.image {ctx in
            outlineImage.draw(at: .zero)
            robotImage.draw(at: CGPoint(x: 240, y: 170))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 285))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 215))
            HorizontalLineImage.draw(at: CGPoint(x: 285, y: 145))
            HorizontalLineImage.draw(at: CGPoint(x: 215, y: 145))
            HorizontalLineImage.draw(at: CGPoint(x: 215, y: 215))
        }
        let demoimage6 = ViewRenderer.image {ctx in
            outlineImage.draw(at: .zero)
            robotImage.draw(at: CGPoint(x: 170, y: 170))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 285))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 215))
            HorizontalLineImage.draw(at: CGPoint(x: 285, y: 145))
            HorizontalLineImage.draw(at: CGPoint(x: 215, y: 145))
            HorizontalLineImage.draw(at: CGPoint(x: 215, y: 215))
            HorizontalLineImage.draw(at: CGPoint(x: 145, y: 215))
            HorizontalLineImage.draw(at: CGPoint(x: 145, y: 145))
        }
        let demoimage7 = ViewRenderer.image {ctx in
            outlineImage.draw(at: .zero)
            robotImage.draw(at: CGPoint(x: 100, y: 170))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 285))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 215))
            HorizontalLineImage.draw(at: CGPoint(x: 285, y: 145))
            HorizontalLineImage.draw(at: CGPoint(x: 215, y: 145))
            HorizontalLineImage.draw(at: CGPoint(x: 215, y: 215))
            HorizontalLineImage.draw(at: CGPoint(x: 145, y: 215))
            HorizontalLineImage.draw(at: CGPoint(x: 145, y: 145))
            HorizontalLineImage.draw(at: CGPoint(x: 75, y: 215))
            VerticalLineImage.draw(at: CGPoint(x: 75, y: 145))
            
        }
        let demoimage8 = ViewRenderer.image {ctx in
            outlineImage.draw(at: .zero)
            robotImage.draw(at: CGPoint(x: 100, y: 100))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 285))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 215))
            HorizontalLineImage.draw(at: CGPoint(x: 285, y: 145))
            HorizontalLineImage.draw(at: CGPoint(x: 215, y: 145))
            HorizontalLineImage.draw(at: CGPoint(x: 215, y: 215))
            HorizontalLineImage.draw(at: CGPoint(x: 145, y: 215))
            HorizontalLineImage.draw(at: CGPoint(x: 145, y: 145))
            HorizontalLineImage.draw(at: CGPoint(x: 75, y: 215))
            VerticalLineImage.draw(at: CGPoint(x: 75, y: 145))
            VerticalLineImage.draw(at: CGPoint(x: 75, y: 75))
            VerticalLineImage.draw(at: CGPoint(x: 145, y: 75))
        }
        let demoimage9 = ViewRenderer.image {ctx in
            outlineImage.draw(at: .zero)
            robotImage.draw(at: CGPoint(x: 100, y: 30))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 285))
            VerticalLineImage.draw(at: CGPoint(x: 285, y: 215))
            HorizontalLineImage.draw(at: CGPoint(x: 285, y: 145))
            HorizontalLineImage.draw(at: CGPoint(x: 215, y: 145))
            HorizontalLineImage.draw(at: CGPoint(x: 215, y: 215))
            HorizontalLineImage.draw(at: CGPoint(x: 145, y: 215))
            HorizontalLineImage.draw(at: CGPoint(x: 145, y: 145))
            HorizontalLineImage.draw(at: CGPoint(x: 75, y: 215))
            VerticalLineImage.draw(at: CGPoint(x: 75, y: 145))
            VerticalLineImage.draw(at: CGPoint(x: 75, y: 75))
            VerticalLineImage.draw(at: CGPoint(x: 145, y: 75))
            VerticalLineImage.draw(at: CGPoint(x: 75, y: 5))
            VerticalLineImage.draw(at: CGPoint(x: 145, y: 5))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.PathView.image = demoimage1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.PathView.image = demoimage2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.PathView.image = demoimage3
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.PathView.image = demoimage4
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.PathView.image = demoimage5
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.PathView.image = demoimage6
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            self.PathView.image = demoimage7
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.PathView.image = demoimage8
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
            self.PathView.image = demoimage9
        }
    }
    
    @IBAction func Forward_Send(_ sender: UIButton) {
        writeValue(characteristic: SendCommandCharateristic, value: 1)
    }
    
    @IBAction func Forward_End(_ sender: UIButton) {
        writeValue(characteristic: SendCommandCharateristic, value: 0)
    }
    
    @IBAction func Backward_Send(_ sender: UIButton) {
        writeValue(characteristic: SendCommandCharateristic, value: 2)
    }
    
    @IBAction func Backward_End(_ sender: UIButton) {
        writeValue(characteristic: SendCommandCharateristic, value: 0)
    }
    
    @IBAction func Left_Send(_ sender: UIButton) {
        writeValue(characteristic: SendCommandCharateristic, value: 3)
    }
    
    @IBAction func Left_End(_ sender: UIButton) {
        writeValue(characteristic: SendCommandCharateristic, value: 0)
    }
    
    @IBAction func Right_Send(_ sender: UIButton) {
        writeValue(characteristic: SendCommandCharateristic, value: 4)
    }
    
    @IBAction func Right_End(_ sender: UIButton) {
        writeValue(characteristic: SendCommandCharateristic, value: 0)
    }
    
    var centralManager: CBCentralManager!
    var ArduinoPeripherial: CBPeripheral!
    var SendCommandCharateristic: CBCharacteristic!
    var ModeSwitchCharacteristic: CBCharacteristic!
    
    let ArduinoServiceCBUUID = CBUUID(string: "19B10000-E8F2-537E-4F6C-D104768A1214")
    let ArduinoModeSwitchCharacteristicCBUUID = CBUUID(string: "2A16")
    let ArduinoSendCommandCharacteristicCBUUID = CBUUID(string: "2A17")
    let ArduinoFrontDistanceCharacteristicCBUUID = CBUUID(string: "3A01")
    let ArduinoLeftDistanceCharacteristicCBUUID = CBUUID(string: "3A02")
    let ArduinoRightDistanceCharacteristicCBUUID = CBUUID(string: "3A03")
    
    var ViewRenderer: UIGraphicsImageRenderer!
    let ImageSize = CGSize(width: 400, height: 400)
    var robotImage: UIImage!
    var outlineImage: UIImage!
    var CurrentWallImage: UIImage!
    var HorizontalLineImage: UIImage!
    var VerticalLineImage: UIImage!
    
    let BlockSize: Int32 = 25 //Real Block
    let WallSize: Int32 = 70  //Vitual Wall in Program
    let RobotWallOffset: Int32 = 25
    
    var CurrentDir: Int8!  //0:N, 1:E, 2:S, 3:W
    var CurrentPos: [Int32]!
    var TurnState: Int8!   //0:no turn, 1:turn in progress, 2:turn finished
    
    var LeftDist: Int32!
    var FrontDist: Int32!
    var RightDist: Int32!
    
    var InitialLeftDist: Int32!
    var InitialFrontDist: Int32!
    var InitialRightDist: Int32!
    
    var MovedBlocks: Int32!
    var MaxMovedBlocks: Int32!
    
    var TurnDir: Int8 = 0
    var DrawWallFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewRenderer = UIGraphicsImageRenderer(size: ImageSize)
        outlineImage = ViewRenderer.image {ctx in
            let outline = CGRect(x: 5, y: 5, width: 355, height: 355)
            ctx.cgContext.addRect(outline)
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.red.cgColor)
            ctx.cgContext.setLineWidth(5)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        robotImage = ViewRenderer.image {ctx in
            let robot = CGRect(x: 0, y: 0, width: 20, height: 20)
            ctx.cgContext.addRect(robot)
            ctx.cgContext.setFillColor(UIColor.green.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.green.cgColor)
            ctx.cgContext.setLineWidth(5)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        HorizontalLineImage = ViewRenderer.image {ctx in
            ctx.cgContext.move(to: CGPoint(x: 0, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 70, y: 0))
            ctx.cgContext.setLineWidth(5)
            ctx.cgContext.setStrokeColor(UIColor.red.cgColor)
            ctx.cgContext.strokePath()
        }
        VerticalLineImage = ViewRenderer.image {ctx in
            ctx.cgContext.move(to: CGPoint(x: 0, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 0, y: 70))
            ctx.cgContext.setLineWidth(5)
            ctx.cgContext.setStrokeColor(UIColor.red.cgColor)
            ctx.cgContext.strokePath()
        }
        
        PathView.image = ViewRenderer.image {ctx in
            outlineImage.draw(at: .zero)
        }
        CurrentWallImage = PathView.image
        Connected.isHidden = true
        Disconnected.isHidden = false
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func initView() {
        PathView.image = ViewRenderer.image {ctx in
            outlineImage.draw(at: .zero)
            CurrentWallImage = outlineImage
            robotImage.draw(at: CGPoint(x: 310, y: 310))
        }
        CurrentDir = 0
        CurrentPos = [310, 310]
        TurnState = 2
        DrawWallFlag = false
    }
    
    func update(){
        if (TurnState == 2) {
            print("Current State 2")
            InitialFrontDist = FrontDist
            MaxMovedBlocks = InitialFrontDist / BlockSize
            MovedBlocks = 0
            updateImage(turnState: 2)
            TurnState = 0
        } else if (TurnState == 1) {
            print("Current State 1")
            if (TurnDir == 1) {
                print("InitialLeftDist =" + String(InitialLeftDist))
                if (FrontDist > InitialLeftDist - 10) {
                    TurnState = 2
                    CurrentDir = (CurrentDir + 3) % 4
                    TurnDir = 0
                }
            } else {
                print("InitialRightDist =" + String(InitialRightDist))
                if (FrontDist > InitialRightDist - 10) {
                    TurnState = 2
                    CurrentDir = (CurrentDir + 1) % 4
                    TurnDir = 0
                }
            }
        } else {
            print("Current State 0")
            let diff = InitialFrontDist - FrontDist
            let CurrentMovedBlocks = diff / BlockSize
            if (CurrentMovedBlocks == MovedBlocks) {
                return
            }
                switch CurrentDir {
                case 0:
                    CurrentPos[1] -= WallSize * (CurrentMovedBlocks - MovedBlocks)
                    
                case 1:
                    CurrentPos[0] += WallSize * (CurrentMovedBlocks - MovedBlocks)
                    
                case 2:
                    CurrentPos[1] += WallSize * (CurrentMovedBlocks - MovedBlocks)
                    
                case 3:
                    CurrentPos[0] -= WallSize * (CurrentMovedBlocks - MovedBlocks)
                    
                default:
                    print("Direction Error1")
                }
                
                updateImage(turnState: 0)
                MovedBlocks = CurrentMovedBlocks
                if (MovedBlocks == MaxMovedBlocks) {
                    TurnState = 1
                    if (RightDist < 20) {
                        TurnDir = 1 //turn left
                        InitialLeftDist = LeftDist
                    } else if (LeftDist < 20) {
                        TurnDir = 2 //turn right
                        InitialRightDist = RightDist
                    }
                }
        }
    }
    
    func updateImage(turnState: Int8) {
        CurrentWallImage = ViewRenderer.image {ctx in
            CurrentWallImage.draw(at: .zero)
            //draw new wall
            switch CurrentDir {
            case 0:
                if (turnState == 2) {
                    HorizontalLineImage.draw(at: CGPoint(x: Int(CurrentPos[0] - RobotWallOffset), y: Int(CurrentPos[1] - WallSize * MaxMovedBlocks - RobotWallOffset)))
                }
                if (LeftDist < 20) {
                    VerticalLineImage.draw(at: CGPoint(x: Int(CurrentPos[0] - RobotWallOffset), y: Int(CurrentPos[1] - RobotWallOffset)))
                }
                if (RightDist < 20) {
                    VerticalLineImage.draw(at: CGPoint(x: Int(CurrentPos[0] + WallSize - RobotWallOffset), y: Int(CurrentPos[1] - RobotWallOffset)))
                }
            case 1:
                if (turnState == 2) {
                    VerticalLineImage.draw(at: CGPoint(x: Int(CurrentPos[0] + WallSize * (MaxMovedBlocks + 1) - RobotWallOffset), y: Int(CurrentPos[1] - RobotWallOffset)))
                }
                if (LeftDist < 20) {
                    HorizontalLineImage.draw(at: CGPoint(x: Int(CurrentPos[0] - RobotWallOffset), y: Int(CurrentPos[1] - RobotWallOffset)))
                }
                if (RightDist < 20) {
                    HorizontalLineImage.draw(at: CGPoint(x: Int(CurrentPos[0] - RobotWallOffset), y: Int(CurrentPos[1] + WallSize - RobotWallOffset)))
                }
            case 2:
                if (turnState == 2) {
                    HorizontalLineImage.draw(at: CGPoint(x: Int(CurrentPos[0] - RobotWallOffset), y: Int(CurrentPos[1] + WallSize * (MaxMovedBlocks + 1) - RobotWallOffset)))
                }
                if (LeftDist < 20) {
                    VerticalLineImage.draw(at: CGPoint(x: Int(CurrentPos[0] + WallSize - RobotWallOffset), y: Int(CurrentPos[1] - RobotWallOffset)))
                }
                if (RightDist < 20) {
                    VerticalLineImage.draw(at: CGPoint(x: Int(CurrentPos[0] - RobotWallOffset), y: Int(CurrentPos[1] - RobotWallOffset)))
                }
            case 3:
                if (turnState == 2) {
                    VerticalLineImage.draw(at: CGPoint(x: Int(CurrentPos[0] - WallSize * MaxMovedBlocks - RobotWallOffset), y: Int(CurrentPos[1] - RobotWallOffset)))
                }
                if (LeftDist < 20) {
                    HorizontalLineImage.draw(at: CGPoint(x: Int(CurrentPos[0] - RobotWallOffset), y: Int(CurrentPos[1] + WallSize - RobotWallOffset)))
                }
                if (RightDist < 20) {
                    HorizontalLineImage.draw(at: CGPoint(x: Int(CurrentPos[0] - RobotWallOffset), y: Int(CurrentPos[1] - RobotWallOffset)))
                }
            default:
                print("Direction Error2")
            }
        }
        PathView.image = ViewRenderer.image {ctx in
            CurrentWallImage.draw(at: CGPoint(x: 0, y: 0))
            robotImage.draw(at: CGPoint(x: Int(CurrentPos[0]), y: Int(CurrentPos[1])))
        }
    }
    
    /**
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 300, height: 300)
            
            // 4
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.red.cgColor)
            ctx.cgContext.setLineWidth(20)
            
            // 5
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        PathView.image = img
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300))
        
        let img = renderer.image { ctx in
            let rect = CGRect(x: 270, y: 270, width: 20, height: 20)
            
            // 6
            ctx.cgContext.setFillColor(UIColor.green.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(1)
            
            ctx.cgContext.addEllipse(in: rect)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        PathView.image = img
    }
    
    func drawLines() {
        // 1
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 280, height: 250))
        
        let img = renderer.image { ctx in
            // 2
            ctx.cgContext.move(to: CGPoint(x: 20.0, y: 20.0))
            ctx.cgContext.addLine(to: CGPoint(x: 260.0, y: 230.0))
            ctx.cgContext.addLine(to: CGPoint(x: 100.0, y: 200.0))
            ctx.cgContext.addLine(to: CGPoint(x: 20.0, y: 20.0))
            
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            // 3
            ctx.cgContext.strokePath()
        }
        
        PathView.image = img
    }
     
     */
    
    
    func writeValue(characteristic: CBCharacteristic!, value: Int8) {
        guard let peripheral = ArduinoPeripherial, let write_characteristic = characteristic else {
            return
        }

        let data = Data.dataWithValue(value: value)
        peripheral.writeValue(data, for: write_characteristic, type: .withResponse)
    }
}


extension ViewController: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
      case .unknown:
        print("central.state is .unknown")
      case .resetting:
        print("central.state is .resetting")
      case .unsupported:
        print("central.state is .unsupported")
      case .unauthorized:
        print("central.state is .unauthorized")
      case .poweredOff:
        print("central.state is .poweredOff")
      case .poweredOn:
        print("central.state is .poweredOn")
        centralManager.scanForPeripherals(withServices: [ArduinoServiceCBUUID])
    
    @unknown default:
        print("central.state is .unknown")
    }
  }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
      print(peripheral)
      ArduinoPeripherial = peripheral
      ArduinoPeripherial.delegate = self
      centralManager.stopScan()
      centralManager.connect(ArduinoPeripherial)
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
      print("Connected!")
        if (Connected.isHidden) {
            Connected.isHidden = false
            Disconnected.isHidden = true
        }
      ArduinoPeripherial.discoverServices([ArduinoServiceCBUUID])
    }
}

extension ViewController: CBPeripheralDelegate {
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else { return }

    for service in services {
      print(service)
      peripheral.discoverCharacteristics(nil, for: service)
    }
  }
    
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                  error: Error?) {
    guard let characteristics = service.characteristics else { return }

    for characteristic in characteristics {
      print(characteristic)
      if characteristic.properties.contains(.notify) {
        print("\(characteristic.uuid): properties contains .notify")
        peripheral.setNotifyValue(true, for: characteristic)
      }
      if characteristic.properties.contains(.write) {
        print("\(characteristic.uuid): properties contains .write")
        if (characteristic.uuid == ArduinoModeSwitchCharacteristicCBUUID) {
            ModeSwitchCharacteristic = characteristic
        } else if (characteristic.uuid == ArduinoSendCommandCharacteristicCBUUID){
            SendCommandCharateristic = characteristic
        }
      }
      if characteristic.properties.contains(.read) {
        print("\(characteristic.uuid): properties contains .read")
        peripheral.readValue(for: characteristic)
      }
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    switch characteristic.uuid {
      case ArduinoFrontDistanceCharacteristicCBUUID:
        print(characteristic.value ?? "no value")
        guard let data = characteristic.value else {
            return
        }
        FrontDist = data.int32Value()
        print(String(FrontDist))
        FrontData.text = String(FrontDist)
      case ArduinoLeftDistanceCharacteristicCBUUID:
        print(characteristic.value ?? "no value")
        guard let data = characteristic.value else {
            return
        }
        LeftDist = data.int32Value()
        print(String(LeftDist))
        LeftData.text = String(LeftDist)
      case ArduinoRightDistanceCharacteristicCBUUID:
        print(characteristic.value ?? "no value")
        guard let data = characteristic.value else {
            return
        }
        RightDist = data.int32Value()
        print(String(RightDist))
        RightData.text = String(RightDist)
      case ArduinoSendCommandCharacteristicCBUUID:
        print(characteristic.value ?? "no value")
      case ArduinoModeSwitchCharacteristicCBUUID:
        print(characteristic.value ?? "no value")
      default:
        print("Unhandled Characteristic UUID: \(characteristic.uuid)")
    }
      if (DrawWallFlag) {
          update()
      }
  }
}


/**
 for test
extension ViewController {
    private func Distance(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return -1 }
        let byteArray = [UInt8](characteristicData)
        return Int(byteArray[0])
      }
}
 */
 

