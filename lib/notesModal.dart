class NotesModel{
  final int? id;
  final String title;
  final String description;
  final String dateTime;

  NotesModel({this.id,required this.title,required this.description,this.dateTime = ""});

  NotesModel.fromMap(Map<String,dynamic> res):
        id = res['id'],
        title = res['title'],
        description = res['description'],
        dateTime = res['dateTime'];

  Map<String,Object?> toMap(){
    return{
      'id' : id,
      'title' : title,
      'description' : description,
      'dateTime' : dateTime,
    };
  }
}