//  Created by TCode on 17/01/2021.

import UIKit
import RxSwift
import RxCocoa

struct StockPrice {
    var title: String
    var price: Float
    var isFavorite: Bool
}

class ViewController: UIViewController {

    let disposeBag = DisposeBag()

    // Input
    private let symbols = ["AAU", "ZOOM", "VOO", "GLD", "APL", "GUD", "NIO", "MEM", "RSA"]
    private var allStocks = BehaviorRelay(value: [StockPrice]())

    // Output
    private var stocks = BehaviorRelay(value: [StockPrice]())

    // Outlets
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        allStocks.accept(symbols.enumerated().map({ (index, sym) -> StockPrice in
            StockPrice(title: sym, price: Float.random(in: 2 ... 200), isFavorite: index % 2 == 0)
        }))

        bindUI()
    }

    private func bindUI() {
        Observable.combineLatest(allStocks.asObservable(), switchControl.rx.isOn, searchTF.rx.text) { (allStocks, onlyFavorites, searchText) -> [StockPrice] in
            return allStocks.filter { (stock) -> Bool in
                self.shouldDisplayStock(stock, onlyFavorites: onlyFavorites, search: searchText)
            }
            }.bind(to: stocks)
            .disposed(by: disposeBag)

        stocks.asObservable()
            .subscribe { [weak self] (value) in
                self?.tableView.reloadData()
            }.disposed(by: disposeBag)
    }

    private func shouldDisplayStock(_ stock: StockPrice, onlyFavorites: Bool, search: String?) -> Bool {
        if onlyFavorites && !stock.isFavorite {
            return false
        }
        if let searchText = search,
           !searchText.isEmpty,
           !stock.title.lowercased().contains(searchText.lowercased()) {
            return false
        }
        return true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "stockCellID", for: indexPath) as? StockCell else {
            return UITableViewCell()
        }
        cell.configure(stock: stocks.value[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

