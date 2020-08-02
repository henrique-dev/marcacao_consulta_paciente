import 'package:marcacao_consulta_paciente/models/Speciality.dart';
import 'package:marcacao_consulta_paciente/models/clinic_profile.dart';

class MedicWorkScheduling {
  int _id;
  int _perDay;
  DateTime _last;
  int _counterOfDay;
  String _info;
  String _daysOfWeek;
  String _complement;
  ClinicProfile _clinicProfile;
  Speciality _speciality;

  MedicWorkScheduling(this._id, this._perDay, this._last, this._counterOfDay,
      this._info, this._daysOfWeek, this._complement, this._clinicProfile, this._speciality);

  ClinicProfile get clinicProfile => _clinicProfile;

  set clinicProfile(ClinicProfile value) {
    _clinicProfile = value;
  }

  String get complement => _complement;

  set complement(String value) {
    _complement = value;
  }

  String get daysOfWeek => _daysOfWeek;

  set daysOfWeek(String value) {
    _daysOfWeek = value;
  }

  String get info => _info;

  set info(String value) {
    _info = value;
  }

  int get counterOfDay => _counterOfDay;

  set counterOfDay(int value) {
    _counterOfDay = value;
  }

  DateTime get last => _last;

  set last(DateTime value) {
    _last = value;
  }

  int get perDay => _perDay;

  set perDay(int value) {
    _perDay = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Speciality get speciality => _speciality;

  set speciality(Speciality value) {
    _speciality = value;
  }

  static MedicWorkScheduling convert(dynamic hash, bool loadSubObjects) {
    MedicWorkScheduling medicWorkScheduling;

    medicWorkScheduling = MedicWorkScheduling(
        hash["id"],
        hash["per_day"],
        hash["last"],
        hash["counter_of_day"],
        hash["info"],
        hash["days_of_week"],
        hash["complement"],
        null,
        null
    );

    return medicWorkScheduling;
  }

}