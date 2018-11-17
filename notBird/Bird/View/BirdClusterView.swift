//
//  BirdClusterView.swift
//  notBird
//


import MapKit
import SnapKit
import Lottie

class BirdClusterView : MKAnnotationView {
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    if let cluster = annotation as? NotBirdCluster {
      self.clusterCountLabel.text = String(cluster.memberAnnotations.count)
    }
    configureView()
  }
  
  let clusterCountLabel : UILabel = {
    let label = UILabel()
    
    label.textColor = .white
    label.textAlignment = .center
    label.font = UIFont(name: "Futura", size: 13)
    label.adjustsFontSizeToFitWidth = true
    
    return label
  }()
  
  private func configureView() {
    let animationView = LOTAnimationView(name: "mappoint", bundle: Bundle.main)
    addSubview(animationView)
    animationView.addSubview(clusterCountLabel)
    clusterCountLabel.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    animationView.animationSpeed = CGFloat.random(in: 0.5...1)
    animationView.loopAnimation = true
    animationView.play()
  }
}
