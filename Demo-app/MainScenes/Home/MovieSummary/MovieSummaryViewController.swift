//
//  MovieSummaryViewController.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import RxCocoa
import RxSwift
import RxDataSources
import UIKit

class MovieSummaryViewController: BaseViewController, UIScrollViewDelegate {

    // MARK: - Views

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var coverHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topTableViewConstraint: NSLayoutConstraint!
    
    // MARK: - Properties

    fileprivate var tableViewDataSource: RxTableViewSectionedReloadDataSource<DetailCollectionsSection>!
    private var viewModel: MovieSummaryViewModel
    private var previousOffsetState: CGFloat = 0
    private var navigationBarHeigth: CGFloat = 44
    private let originalTopConstraintForTableView: CGFloat = 75

    // MARK: - Lifecycle

    init(viewModel: MovieSummaryViewModel) {
        self.viewModel = viewModel

        super.init(nibName: String(describing: type(of: self)), bundle: nil)
        
        hideTabBar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        showTabBar()
    }
    
    // MARK: - Setup
    
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(UINib(nibName: SinopsisCell.nibName, bundle: nil), forCellReuseIdentifier: SinopsisCell.cellIdentifier)
        tableView.register(UINib(nibName: DetailsCell.nibName, bundle: nil), forCellReuseIdentifier: DetailsCell.cellIdentifier)
        tableView.register(UINib(nibName: ReviewCell.nibName, bundle: nil), forCellReuseIdentifier: ReviewCell.cellIdentifier)
    }

    // MARK: - Overrides

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupStatusBar(isLightMode: true)
        showNavigationBar(animated: false, showLogo: true)
    }

    override func setupUI() {
        super.setupUI()
        
        addBackButton()
        setupTableView()
    }

    override func setupBindings() {
        super.setupBindings()
        
        backButtonItem?.rx.tap
            .bind(to: viewModel.input.goBackTrigger)
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .bind(to: self.rx.simpleErrorMessage)
            .disposed(by: disposeBag)

        viewModel.output.infoMessage
            .bind(to: self.rx.simpleMessage)
            .disposed(by: disposeBag)
        
        viewModel.output.movie
            .map { movie -> String? in
                return movie.posterPath
            }.bind(to: self.coverImage.rx.setMoviePosterImage)
            .disposed(by: disposeBag)
        
        tableViewDataSource = RxTableViewSectionedReloadDataSource<DetailCollectionsSection>(configureCell: { dataSource, tableView, indexPath, elements in
            switch elements {
            case .detail(let movie):
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.cellIdentifier, for: indexPath) as! DetailsCell
                cell.setup(withMovie: movie)
                
                return cell
            case .sinopsis(let movie):
                let cell = tableView.dequeueReusableCell(withIdentifier: SinopsisCell.cellIdentifier, for: indexPath) as! SinopsisCell
                cell.setup(withMovie: movie)
                
                return cell
            case .review(let review):
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.cellIdentifier, for: indexPath) as! ReviewCell
                cell.setup(withReview: review)
                
                return cell
            }
        })
        
        Observable.combineLatest(viewModel.output.movie, viewModel.output.reviews)
            .map { (movie, reviews) in                
                let detailItem: [DetailCollectionItem] = [.detail(movie: movie)]
                var sections: [DetailCollectionsSection] = [DetailCollectionsSection(items: detailItem)]
                
                let sinopsisItem: [DetailCollectionItem] = [.sinopsis(movie: movie)]
                sections.append(DetailCollectionsSection(items: sinopsisItem))
                
                var reviewsItems: [DetailCollectionItem] = []
                reviews.forEach { review in
                    let reviewItem: DetailCollectionItem = .review(review: review)
                    reviewsItems.append(reviewItem)
                }
                
                if !reviewsItems.isEmpty {
                    sections.append(DetailCollectionsSection(items: reviewsItems))
                }
                
                return sections
            }.bind(to: tableView.rx.items(dataSource: tableViewDataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.input.tryFetchingReviewsTrigger.onNext(())
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (200 + self.navigationBarHeigth) {
            self.coverHeightConstraint.constant = 0
            return
        }
        
        navigationItem.title = String()
        let offsetDiff = self.previousOffsetState - scrollView.contentOffset.y
        self.previousOffsetState = scrollView.contentOffset.y
        let newHeight = self.coverHeightConstraint.constant + offsetDiff
        self.coverHeightConstraint.constant = newHeight
    }
    
    // MARK: - Private methods
    
    private func updateTableView(at indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }

}

// MARK: - Details RxDataSource

enum DetailCollectionItem {
    case detail(movie: Movie)
    case sinopsis(movie: Movie)
    case review(review: Review)
}

fileprivate struct DetailCollectionsSection {

    var items: [DetailCollectionItem] = []
}

extension DetailCollectionsSection: SectionModelType {
    
    typealias Item = DetailCollectionItem

    init(original: DetailCollectionsSection, items: [Item]) {
        
        self = original
        self.items = items
    }
    
}

extension MovieSummaryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 0 ? 60 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        headerView.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 16, y: 8, width: headerView.frame.width, height: headerView.frame.height)
        if section == 1 {
            titleLabel.text = "Sinopsis".localize()
        } else if section == 2 {
            titleLabel.text = "Top Reviews".localize()
        } else {
            titleLabel.text = ""
        }
        titleLabel.textColor = Colors.customGray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
}

