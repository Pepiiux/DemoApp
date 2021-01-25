//
//  HomeViewController.swift
//  Demo-app
//
//  Created by Hector Alvarado on 23/01/21.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import UIKit
import RxGesture

class HomeViewController: BaseViewController, UIScrollViewDelegate {

    // MARK: - Views

    @IBOutlet weak var filtersContainerView: ShadowedView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortingCriteriaPickerView: UIPickerView!
    @IBOutlet weak var sortCriteriaLabel: UILabel!
    
    // MARK: - Properties

    private var viewModel: HomeViewModel
    private var dataSource: RxCollectionViewSectionedReloadDataSource<CatalogCollectionsSection>!

    // MARK: - Lifecycle

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel

        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    
    fileprivate func setupCollectionView() {
        collectionView.register(UINib(nibName: movieCell.nibName, bundle: nil), forCellWithReuseIdentifier: movieCell.cellIdentifier)
    }
    
    // MARK: - Overrides
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupStatusBar(isLightMode: true)
        showNavigationBar(animated: false, showLogo: true)
    }
    
    override func setupUI() {
        super.setupUI()
        
        navigationItem.setHidesBackButton(true, animated: false)
        setupCollectionView()
    }

    override func setupBindings() {
        super.setupBindings()
        
        viewModel.output.errorMessage
            .bind(to: self.rx.simpleErrorMessage)
            .disposed(by: disposeBag)

        viewModel.output.infoMessage
            .bind(to: self.rx.simpleMessage)
            .disposed(by: disposeBag)

        viewModel.output.isLoading
            .bind(to: self.rx.isLoading)
            .disposed(by: disposeBag)
                
        viewModel.output.moviesSortingCriteria
            .map { $0.title }
            .bind(to: sortCriteriaLabel.rx.text)
            .disposed(by: disposeBag)
        
        filtersContainerView.rx.tapGesture()
            .when(.recognized)
            .do(onNext: { [weak self] (_) in
                self?.sortingCriteriaPickerView.isHidden = false
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        Observable.just(MoviesSortingCriteria.getAll())
            .bind(to: sortingCriteriaPickerView.rx.itemTitles) { (_, element) in
                return element.title
            }.disposed(by: disposeBag)
        
        viewModel.output.movies
            .bind(to: collectionView.rx.items(cellIdentifier: movieCell.cellIdentifier, cellType: movieCell.self)) { [weak self] (row, movie, cell) in
                guard let strongSelf = self else {
                    return
                }
                
                cell.paddingOffset = 30
                cell.setup(movie: movie)
                let bounds = strongSelf.collectionView.bounds
                cell.parallaxOffset(collectionViewBounds: bounds, scrollDirecton: .vertical)
            }.disposed(by: disposeBag)
        
        sortingCriteriaPickerView.rx.modelSelected(MoviesSortingCriteria.self)
            .map({ components in
                guard let selectedOption = components.first else {
                    return .mostPopular
                }
                
                return selectedOption
            })
            .do(onNext: { [weak self] (_) in
                self?.sortingCriteriaPickerView.isHidden = true
            })
            .bind(to: viewModel.input.tryFetchingMoviesTrigger)
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Movie.self)
            .bind(to: viewModel.input.goToMovieSummaryTrigger)
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.input.tryFetchingMoviesTrigger.onNext(.mostPopular)
    }

    // MARK: - Private methods
    
    private func setupViews() {
        filtersContainerView.layer.cornerRadius = filtersContainerView.frame.size.height / 2.0
        filtersContainerView.isUserInteractionEnabled = true
        sortingCriteriaPickerView.backgroundColor = .white
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cells = collectionView.visibleCells as! [movieCell]
        let bounds = collectionView.bounds
        for cell in cells {
            cell.parallaxOffset(collectionViewBounds: bounds, scrollDirecton: .vertical)
        }
    }
    
}

// MARK: - Spend items RxDataSource

enum CatalogItem {
    case movie(movie: Movie)
}

fileprivate struct CatalogCollectionsSection {

    var items: [Item] = []
}

extension CatalogCollectionsSection: SectionModelType {
    
    typealias Item = CatalogItem

    init(original: CatalogCollectionsSection, items: [Item]) {
        self = original
        self.items = items
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  0
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: (collectionViewSize - 30)/2, height: 280)
    }
    
}
