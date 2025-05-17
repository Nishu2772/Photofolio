class ImageItem {
  final String downloadUrl;

  ImageItem({required this.downloadUrl});

  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(downloadUrl: json['download_url']);
  }
}
