//
//  WelcomeVC.swift
//  City Spriiint Driver
//
//  Created by Techimmense Software Solutions on 21/07/23.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnNextOt: UIButton!
    
    let identifier = "WelcomeCell"

    var currentIndex = 0
    
    var arrName =
    [
    "Register Vehicle",
    "Upload Documents",
    "Earn Money"
    ]

    var arrImageList =
    [
        R.image.slide1(),
        R.image.slide2(),
        R.image.slide3()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func btnNext(_ sender: UIButton) {
        if self.currentIndex < (self.arrImageList.count - 1) {
            self.currentIndex = self.currentIndex + 1
            self.pageControl.currentPage = self.currentIndex
            print(pageControl.currentPage)
            print(currentIndex)
            print(self.arrImageList.count)
            DispatchQueue.main.async {
                self.collectionView.isPagingEnabled = false
                self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: true
                )
                self.collectionView.isPagingEnabled = true
            }
        }else{
            let vc = R.storyboard.main().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnSkip(_ sender: UIButton) {
        let vc = R.storyboard.main().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension WelcomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrImageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomeCell", for: indexPath) as! WelcomeCell
        cell.lblName.text = self.arrName[indexPath.row]
        cell.img.image = self.arrImageList[indexPath.row]
        return cell
    }
}

extension WelcomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: 600)
    }
}

extension WelcomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
        self.currentIndex = indexPath.row
        if indexPath.row == 2 {
            self.btnNextOt.setTitle("Start", for: .normal)
        } else {
            self.btnNextOt.setTitle("Next", for: .normal)
        }
    }
}

