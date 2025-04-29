import UIKit
import PhotosUI
import UniformTypeIdentifiers

class ImagePicker: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var viewController: UIViewController?
    var imagePickedBlock: (([(Data, String?)]) -> Void)?

    func presentActionSheet(from viewController: UIViewController, imagePicked: @escaping ([(Data, String?)]) -> Void) {
        self.viewController = viewController
        self.imagePickedBlock = imagePicked

        let alert = UIAlertController(title: "Choose how you want to add a photo", message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
                self.presentCamera()
            })
        }

        alert.addAction(UIAlertAction(title: "Gallery", style: .default) { _ in
            self.presentImagePicker()
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        viewController.present(alert, animated: true, completion: nil)
    }

    private func presentImagePicker() {
        guard let viewController = self.viewController else { return }

        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController.present(picker, animated: true, completion: nil)
    }

    private func presentCamera() {
        guard let viewController = self.viewController else { return }

        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.delegate = self
        camera.allowsEditing = false
        viewController.present(camera, animated: true, completion: nil)
    }

    private func compressImageToUnder5MB(_ image: UIImage) -> Data? {
        var compressionQuality: CGFloat = 1.0
        let maxFileSize = 2 * 1024 * 1024
        
        guard var data = image.jpegData(compressionQuality: compressionQuality) else { return nil }
        
        while data.count > maxFileSize && compressionQuality > 0 {
            compressionQuality -= 0.1
            if let newData = image.jpegData(compressionQuality: compressionQuality) {
                data = newData
            } else {
                break
            }
        }
        
        return data.count <= maxFileSize ? data : nil
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        var selectedImages: [(Data, String?)] = []
        let group = DispatchGroup()

        for result in results {
            group.enter()

            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                defer { group.leave() }

                guard let url = url else { return }
                let fileExtension = (url.lastPathComponent as NSString).pathExtension.lowercased()

                if (fileExtension == "jpg" || fileExtension == "jpeg"),
                   let image = UIImage(contentsOfFile: url.path),
                   let data = self.compressImageToUnder5MB(image) {
                    selectedImages.append((data, url.lastPathComponent))
                }
            }

            if selectedImages.count >= 1 {
                break
            }
        }

        group.notify(queue: .main) {
            self.imagePickedBlock?(selectedImages)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage,
           let data = compressImageToUnder5MB(image) {
            imagePickedBlock?([(data, "photo.jpg")])
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
