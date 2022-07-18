![header](https://capsule-render.vercel.app/api?type=waving&color=gradient&width=100%&height=300&section=header&text=Mini-Market&fontSize=90&descAlignY=70)


## 프로젝트 소개
>HTTP 통신을 활용하여 마켓 앱 구현

### 키워드
> - UIKit
>- UITableView
>- UIAlertController
>- UIImagePicker
>- URLSession
>- multipart/form-Data
>- 동적인 스크롤뷰의 활용
>- Delegate 패턴
>- NotificationCenter
>- jsonParser
>- RefreshControl
### 개발 환경
> ![](https://img.shields.io/badge/Xcode-13.2.1-blue) ![](https://img.shields.io/badge/Swift-5.5-orange) 

### 구동 화면
- 상품 조회
    >| 이미지 캐시 적용 전| 후 |
    >| - | - |
    >| ![](https://i.imgur.com/mhUsNT1.gif) | ![](https://i.imgur.com/6ho5hXH.gif) |
    

    
    
    
    >|스와이프하여 리프레쉬 적용|
    >|-|
    >| <img src="https://i.imgur.com/81Zq0h2.gif">|




- 상품 등록

    >|상품 등록|
    >|-|
    >|![](https://i.imgur.com/E1c625x.gif)|
    

    >|입력에 따른 키보드 위치 조정 전| 후 |
    >| - | - |
    >| ![](https://i.imgur.com/f03jzbe.gif) | ![](https://i.imgur.com/YwEvEmw.gif) |
    
    
    
    >|입력해야하는 값에 따른 자판 조정 |
    >|-|
    >|![](https://i.imgur.com/kTUUqyt.gif)|
    

- 상품 삭제
    
    >|상품 삭제 실패| 상품 삭제 성공 |
    >| - | - | 
    >| ![](https://i.imgur.com/JTLkbI8.gif) | ![](https://i.imgur.com/7wrZ96u.gif) |

    

## 기능

-  스토리보드의 분리
     > 스토리보드의 충돌을 방지하기 위해 뷰마다 스토리보드를 완전히 분리하여 개발했습니다.
     > |스토리보드|
     > |-|
     > |![](https://i.imgur.com/yC52q34.png)|
     >     
     >    |메인화면|상품상세화면|상품등록화면|
     >    |-|-|-|
     >    |<img src=https://i.imgur.com/2wV2XSt.png>|![](https://i.imgur.com/QJX4UVk.png)|![](https://i.imgur.com/z5Jt8TM.png)



- 데이터의 전달이 필요한 경우 각 뷰가 서로 의존하지 않도록 생성자 주입 방식으로 화면을 띄워주었습니다.
    >    ```swift
    >        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    >            let detailStoryboard = UIStoryboard(name: "DetailView", bundle: nil)
    >            let detailViewController = detailStoryboard.instantiateViewController(identifier: "DetailViewController") { coder in
    >            return DetailViewController(coder: coder, product: self.products?[indexPath.row])
    >        }
    >        
    >        detailViewController.delegate = self
    >        self.navigationController?.pushViewController(detailViewController, animated: true)
    >    }
    > ```

- ImageCache 적용
    > 상품의 썸네일을 매번 서버로부터 요청받아 화면에 띄우는 것은 비효율적이라고 생각을 하여, NSCache를 이용하여 메모리 캐시를 도입했습니다. 메모리에 이미지가 존재한다면 이미지를 반환해주고, 존재하지 않는다면 서버에 요청해 이미지를 받아옵니다. 요청 시 이미지를 성공적으로 받아왔다면 캐시에 저장하여 다음번에 이미지를 사용하는 경우 캐시에서 이미지를 받아올 수 있도록 했습니다.

- 상품의 삭제 성공 시 메인화면으로 이동
    > 상품을 삭제 했을 경우, 더 이상 해당화면에서 사용자가 제어할 수 없도록 삭제완료 알람을 띄운 후 메인화면으로 바로 이동하도록 구현하였습니다.

- 키보드 입력
    > 사용자의 경험의 향상을 위해 NotificationCenter를 통해 키보드 제어를 구현했습니다.
    > ```swift
    > func setKeyboardObserver() {
    >    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    >    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    >}
    >
    > @objc func keyboardWillShow(notification: NSNotification) {
    >   guard let userInfo = notification.userInfo else {
    >      return
    > }
    > 
    >   var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
    >   keyboardFrame = self.view.convert(keyboardFrame, from: nil)
    >
    >   let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.size.height, right: 0.0)
    >   scrollView.contentInset = contentInset
    > }
    >
    > @objc func keyboardWillHide(notification: NSNotification) {
    >    let contentInset = UIEdgeInsets.zero
    >    scrollView.contentInset = contentInset
    > }

- Refresh
    > 새로 상품이 업데이트 된 경우, 어플을 종료했다가 다시 실행시킬 필요없이 스와이프를 통해 새로운 제품을 볼 수 있도록 구현하였습니다.

- API 관리
    > API를 열거형으로 관리하는 경우, 새로운 case를 생성할때마다 관련된 switch문을 매번 수정해야하는 번거로움이 존재합니다. 따라서 API마다 독립적인 구조체타입으로 관리되도록 변경하였습니다. 이로써 코드유지 보수가 용이하며, 문제 발생 시 빠르게 어디에서 생긴 오류인지 명확하게 구분지을 수 있습니다. 
    > ```swift
    > // 개선되기 전
    > protocol URLProtocol {  
    >     var url: URL? { get }
    > }
    >
    > extension URLRequest {
    >     init?(url: URLProtocol) {
    >     guard let url = url.url else {
    >        return nil
    >     }
    >    self.init(url: url)
    >   }
    > }
    >
    > enum OpenMarketURL: URLProtocol {   
    > private static let apiHost = "https://market-training.yagom-academy.kr/"
    >    case healthChecker
    >    case productDetail(id: Int)
    > 
    > 
    >    var url: URL? {
    >         switch self {
    >         case .healthChecker:
    >               return URL(string: "\(OpenMarketURL.apiHost)healthChecker")
    >         case .productDetail(let id):
    >               return URL(string: "\(OpenMarketURL.apiHost)api/products/\(id)")
    > ```              


    > ```swift
    > // 개선 후
    > protocol APIProtocol {
    >      var url: URL? { get }
    > }
    >
    > extension URLRequest {
    >      init?(api: APIProtocol) {
    >      guard let url = api.url else {
    >          return nil
    >      }
    >    
    >       self.init(url: url) 
    >        }
    >     }
    >
    >    struct HealthCheckerAPI: APIProtocol {
    >    var url: URL?
    >
    >    init(baseURL: BaseURLProtocol = OpenMarketBaseURL()) {
    >    self.url = URL(string: "\(baseURL.baseURL)healthChecker")
    >        }
    >    }
    >
    >    struct ProductDetailAPI: APIProtocol {
    >    var url: URL?
    >    
    >    init(_ id: Int, baseURL: BaseURLProtocol = OpenMarketBaseURL()) {
    >        self.url = URL(string: "\(baseURL.baseURL)api/products/\(id)")
    >      }
    >   }
    >   ```

