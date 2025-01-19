class ChatFunction {
  String name;
  String description;
  Map<String, dynamic> parameters;
  List<String>? requiredParameters;
  Function? function;

  ChatFunction({
    required this.name,
    required this.description,
    required this.parameters,
    this.requiredParameters,
    this.function,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> properties = {};
    parameters.forEach((key, value) {
      properties[key] = {
        'type': value['type'],
        'description': value['description'],
      };
    });

    Map<String, dynamic> json = {
      "name": name,
      "description": description,
      "parameters": {
        "type": "object",
        "properties": properties,
      },
    };

    if (requiredParameters != null && requiredParameters!.isNotEmpty) {
      json["parameters"]["required"] = requiredParameters;
    }

    return json;
  }
}
