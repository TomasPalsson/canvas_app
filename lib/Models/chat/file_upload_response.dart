class FileUploadResponse {
  final String id;
  final String purpose;
  final String filename;
  final int bytes;
  final String status;

  FileUploadResponse({
    required this.id,
    required this.purpose,
    required this.filename,
    required this.bytes,
    required this.status,
  });

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) {
    return FileUploadResponse(
      id: json['id'] as String,
      purpose: json['purpose'] as String,
      filename: json['filename'] as String,
      bytes: json['bytes'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'purpose': purpose,
        'filename': filename,
        'bytes': bytes,
        'status': status,
      };
}
