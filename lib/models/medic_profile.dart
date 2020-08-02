import 'package:marcacao_consulta_paciente/models/speciality.dart';

class MedicProfile {

  int _id;
  String _name;
  String _genre;
  DateTime _birthDate;
  double _height;
  double _weight;
  String _bloodType;
  String _telephone;
  List<Speciality> _specialities;

  MedicProfile(this._id, this._name, this._genre, this._birthDate, this._height,
      this._weight, this._bloodType, this._telephone, this._specialities);

  List<Speciality> get specialities => _specialities;

  set specialities(List<Speciality> value) {
    _specialities = value;
  }

  String get telephone => _telephone;

  set telephone(String value) {
    _telephone = value;
  }

  String get bloodType => _bloodType;

  set bloodType(String value) {
    _bloodType = value;
  }

  double get weight => _weight;

  set weight(double value) {
    _weight = value;
  }

  double get height => _height;

  set height(double value) {
    _height = value;
  }

  DateTime get birthDate => _birthDate;

  set birthDate(DateTime value) {
    _birthDate = value;
  }

  String get genre => _genre;

  set genre(String value) {
    _genre = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  static List<MedicProfile> convertList(dynamic data) {
    List<MedicProfile> medicProfileList = List();

    for (Map<String, dynamic> hash in data) {
      MedicProfile profile = MedicProfile(
        hash["id"],
        hash["name"],
        hash["genre"],
        DateTime.tryParse(hash["birth_date"]),
        double.tryParse(hash["height"]),
        double.tryParse(hash["weight"]),
        hash["blood_type"],
        hash["telephone"],
        Speciality.convertList(hash["specialities"])
      );
      medicProfileList.add(profile);
    }

    return medicProfileList;
  }

  static MedicProfile convert(dynamic hash, bool loadSubObjects) {
    MedicProfile medicProfile;

    medicProfile = MedicProfile(
        hash["id"],
        hash["name"],
        hash["genre"],
        DateTime.tryParse(hash["birth_date"]),
        double.tryParse(hash["height"]),
        double.tryParse(hash["weight"]),
        hash["blood_type"],
        hash["telephone"],
        loadSubObjects ? Speciality.convertList(hash["specialities"]) : null
    );

    return medicProfile;
  }
  
}