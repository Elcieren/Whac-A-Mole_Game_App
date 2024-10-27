## Whac A Mole Game App
<img src="https://github.com/user-attachments/assets/47cee6b0-925d-4b82-b410-ca5b0a113bc4" alt="Ekran-Kaydı-2024-10-18" style="width:1024px; height:768px;" />

<details>
    <summary><h2>Uygulma Amacı</h2></summary>
  Oyunda ekranda rastgele belirip kaybolan düşmanları veya dostları vurarak puan kazanmak veya kaybetmek mümkün. Oyuncunun amacı, dost karakterlere dokunarak puan kazanırken, düşman karakterlerden kaçınmaktır.
  </details> 
  
  <details>
    <summary><h2>Giriş ve Değişken Tanımlamaları</h2></summary>
    gameScore: Puan etiketini görüntülemek için kullanılan bir nesne.
    slots: Düşman karakterlerin çıkacağı konumları belirleyen bir dizi.
    popupTime: Düşmanların görünme hızını belirler, her turda azalır.
    score: Oyuncunun mevcut puanı; değiştiğinde etiketi otomatik olarak günceller.
    
    ```
    import SpriteKit

    class GameScene: SKScene {
    // Oyuncunun puanını gösteren bir SKLabelNode etiketi.
    var gameScore: SKLabelNode!
    // WhackSlot nesnelerinden oluşan bir dizi.
    var slots = [WhackSlot]()
    // Düşmanların görünme hızını kontrol eden bir değişken
    var popupTime = 2.0
    var numRounds = 0
    
    var score = 0 {
        didSet {
            if let scoreLabel = gameScore {
                scoreLabel.text = "Score: \(score)"
            }
        }
    }

    ```
  </details> 

  <details>
    <summary><h2>configure(at:) Fonksiyonu</h2></summary>
    whackHole: Slotun arka planında karakterin görüneceği delik.
    cropNode: Karakterin belirli bir maskeye göre görünmesini sağlar.
    charNode: Karakter olarak tanımlanan penguen sprite'ı burada eklenir.

    
    ```
    func configure(at position: CGPoint) {
    self.position = position
    let sprite = SKSpriteNode(imageNamed: "whackHole")
    addChild(sprite)
    
    let cropNode = SKCropNode()
    cropNode.position = CGPoint(x: 0, y: 15)
    cropNode.zPosition = 1
    cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
    
    charNode = SKSpriteNode(imageNamed: "penguinGood")
    charNode.position = CGPoint(x: 0, y: -90)
    charNode.name = "character"
    cropNode.addChild(charNode)
    addChild(cropNode)
    }



    ```
  </details> 




<details>
    <summary><h2>show(hideTime:) Fonksiyonu</h2></summary>
    Penguen türü belirleme: Rastgele bir değer ile karakterin dost (charFriend) veya düşman (charEnemy) olacağı belirlenir.
    Görünürlük ve süre: Karakter belirli bir süre ekranda kaldıktan sonra gizlenir.

    
    ```
    func show(hideTime: Double) {
    if isVisible { return }
    charNode.xScale = 1
    charNode.yScale = 1
    
    charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
    isVisible = true
    isHit = false
    
    if Int.random(in: 0...2) == 0 {
        charNode.texture = SKTexture(imageNamed: "penguinGood")
        charNode.name = "charFriend"
    } else {
        charNode.texture = SKTexture(imageNamed: "penguinEvil")
        charNode.name = "charEnemy"
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 0.35)) { [weak self] in
        self?.hide()
    }
    }




    ```
  </details>

  <details>
    <summary><h2>hide() Fonksiyonu</h2></summary>
   isVisible kontrolü: Eğer karakter zaten görünmüyorsa işlemi tekrar etmez.
   Animasyon: Karakter yavaşça gizlenir.

    
    ```
    func hide() {
    if !isVisible { return }
    charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
    isVisible = false
     }




    ```
  </details>
  <details>
    <summary><h2>hit() Fonksiyonu</h2></summary>
   Vurulma animasyonu: Karakterin vurulma efektini gösterir, önce bekler, sonra aşağıya doğru kayarak gizlenir.
  Vurulma sonrası gizleme: isVisible false olarak ayarlanır, böylece karakter tekrar görünebilir hale gelir

    
    ```
    func hit() {
    isHit = true
    let delay = SKAction.wait(forDuration: 0.25)
    let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
    let noteVisible = SKAction.run { [weak self] in
        self?.isVisible = false
    }
    let sequence = SKAction.sequence([delay, hide, noteVisible])
    charNode.run(sequence)
    }





    ```
  </details>
  <details>
    <summary><h2>creatEnemy() Fonksiyonu</h2></summary>
   Düşmanların görünme süresi: Her turda popupTime azaltılır, böylece düşmanlar daha hızlı görünür.
   Düşman ekleme koşulları: Rastgele değerlere göre kaç adet düşmanın görünmesi gerektiği belirlenir.
   Gecikme: Düşmanların görünme süresi rastgele bir aralıkta ayarlanır.


    
    ```
    func creatEnemy() {
    numRounds += 1
    if numRounds >= 30 {
        for slot in slots {
            slot.hide()
        }
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        gameOver.name = "game"
        addChild(gameOver)
        
        let again = SKSpriteNode(imageNamed: "agains")
        again.position = CGPoint(x: 500, y: 250)
        again.zPosition = 1
        again.name = "again"
        addChild(again)
        return
    }
    
    popupTime *= 0.95
    slots.shuffle()
    let hideTime = popupTime * 1.5
    slots[0].show(hideTime: hideTime)
    
    if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: hideTime) }
    if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: hideTime) }
    if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: hideTime) }
    if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: hideTime) }
    
    let minDelay = popupTime * 0.5
    let maxDelay = popupTime * 2
    let delay = Double.random(in: minDelay...maxDelay)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
        self?.creatEnemy()
    }
    }





    ```
  </details>

  <details>
    <summary><h2>touchesBegan(_:with:) Fonksiyonu</h2></summary>
   touches.first: Kullanıcının dokunduğu noktayı alır.
    Dost karaktere vurma: charFriend karakterine vurulursa puan artırılır ve ses çalar.
   Düşman karaktere vurma: charEnemy karakterine vurulursa puan düşer.


    
    ```
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let tappedNodes = nodes(at: location)
    
    for node in tappedNodes {
        print("Tapped node: \(node.name ?? "unknown")")
        if node.name == "again" {
            starGame()
            return
        }
        guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
        if !whackSlot.isVisible || whackSlot.isHit { continue }
        whackSlot.hit()
        
        if node.name == "charFriend" {
            whackSlot.charNode.xScale = 0.85
            whackSlot.charNode.yScale = 0.85
            score += 1
            run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
        } else if node.name == "charEnemy" {
            score -= 5
            run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
        }
    }
    }
    ```
  </details>

  <details>
    <summary><h2>creatSlot(at:) Fonksiyonu</h2></summary>
   Bu fonksiyon, belirtilen konumda bir WhackSlot oluşturur ve oyuna ekler.


    
    ```
    func creatSlot(at position: CGPoint) {
    let slot = WhackSlot()
    slot.configure(at: position)
    addChild(slot)
    slots.append(slot)
    }





    ```
  </details>

  <details>
    <summary><h2>starGame() Fonksiyonu</h2></summary>
   Oyun sahnesi sıfırlama: Mevcut tüm nesneler kaldırılır ve puan sıfırlanır.
   Arka plan ve puan etiketi: Oyunun arka planı ve puan etiketi eklenir.
   Slotların oluşturulması: Oyunda penguenlerin görünmesi için slotlar farklı konumlarda oluşturulur.


    
    ```
    func starGame() {
    removeAllChildren()
    score = 0
    numRounds = 0
    popupTime = 1.5

    let background = SKSpriteNode(imageNamed: "whackBackground")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)

    gameScore = SKLabelNode(fontNamed: "Chalkduster")
    gameScore.text = "Score: 0"
    gameScore.position = CGPoint(x: 8, y: 8)
    gameScore.horizontalAlignmentMode = .left
    gameScore.fontSize = 48
    addChild(gameScore)

    for i in 0..<5 {
        creatSlot(at: CGPoint(x: 100 + (i * 170), y: 410))
    }
    for i in 0..<4 {
        creatSlot(at: CGPoint(x: 180 + (i * 170), y: 320))
    }
    for i in 0..<5 {
        creatSlot(at: CGPoint(x: 100 + (i * 170), y: 230))
    }
    for i in 0..<4 {
        creatSlot(at: CGPoint(x: 180 + (i * 170), y: 140))
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
        self?.creatEnemy()
    }
    }






    ```
  </details>
  
  
<details>
    <summary><h2>Uygulama Görselleri </h2></summary>
    
    
 <table style="width: 100%;">
    <tr>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Oyundan Rastegele Gorseller 1 </h4>
            <img src="https://github.com/user-attachments/assets/9cf2ed14-585f-413f-a6e8-3473ea84fa93" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Oyundan Rastegele Gorseller 2</h4>
            <img src="https://github.com/user-attachments/assets/012abbd1-7b98-4a87-9e76-8326fd117122" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Oyun Sonu (30 Tur)</h4>
            <img src="https://github.com/user-attachments/assets/f4f23f8f-58df-4192-8cdc-d0fc0703a71f" style="width: 100%; height: auto;">
        </td>
    </tr>
</table>
  </details> 
