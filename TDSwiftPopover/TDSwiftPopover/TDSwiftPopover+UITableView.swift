import Foundation
import UIKit

extension TDSwiftPopover: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.selectionStyle = .none
        cell.imageView?.image = items[indexPath.row].iconImage
        cell.textLabel?.text = items[indexPath.row].titleText
        cell.textLabel?.font = self.itemTitleFont
        cell.textLabel?.textColor = self.itemTitleColor
        cell.backgroundColor = .clear
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(item: items[indexPath.row], atIndex: indexPath.row)
        animatePopover(animationType: .hide)
    }
}
