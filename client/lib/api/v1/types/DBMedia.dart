
import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DBMedia.g.dart';

// @Collection()
// @JsonSerializable()
// class DBMedia {
//   @Id()
//   int id;

//   late String name;

//   DBMedia({required this.id, required})

//   factory DBMedia.fromJson(Map<String, dynamic> json) => _$DBMediaFromJson(json);

//   Map<String, dynamic> toJson() => _$DBMediaToJson(this);

// }

@Collection()
@JsonSerializable()
class DBMedia {
    DBMedia({
      required this.encoding,
      required this.metadata,
      required this.files,
        this.isarID,
       required this.mongoID,
       required this.groupID,
       required this.type,
       required this.uploaded,
       required this.lastModified,
       required this.creationDate,
        this.blurhash,
    });

    @Id()
    int? isarID;

    @Index(type: IndexType.hash, unique: true)
    @JsonKey(name: "_id")
    String mongoID;


    // String? get id => mongoID;
    // set id(String? val) {
    //   mongoID = val;
    // }

    //double? get encoding___progress => encoding?.progress;

     @_DBMediaEncodingConverter()
     DBMediaEncoding? encoding;

    @_DBMediaMetadataConverter()
    DBMediaMetadata metadata;

    @_DBMediaFilesConverter()
    DBMediaFiles files;

    String groupID;
    String type;
    DateTime uploaded;
    DateTime lastModified;
    DateTime creationDate;
    String? blurhash;


    factory DBMedia.fromJson(Map<String, dynamic> json) => _$DBMediaFromJson(json);
    Map<String, dynamic> toJson() => _$DBMediaToJson(this);
}

@JsonSerializable()
class DBMediaEncoding {
    DBMediaEncoding({
       required this.progress,
        this.started,
        this.finished,
    });

    double progress;
    DateTime? started;
    DateTime? finished;

    factory DBMediaEncoding.fromJson(Map<String, dynamic> json) => _$DBMediaEncodingFromJson(json);
    Map<String, dynamic> toJson() => _$DBMediaEncodingToJson(this);
}
class _DBMediaEncodingConverter extends TypeConverter<DBMediaEncoding?, String>{
  const _DBMediaEncodingConverter();
  
  @override
  DBMediaEncoding? fromIsar(String object) {
    //if(object == null) return null;
    return DBMediaEncoding.fromJson(jsonDecode(object));
  }

  @override
  String toIsar(DBMediaEncoding? object) {
    return jsonEncode(object?.toJson());
  }
}

@JsonSerializable()
class DBMediaFiles {
    DBMediaFiles({
        this.thumbnail,
        this.display,
    });
    @_DBMediaFilesThumbnailConverter()
    DBMediaFilesThumbnail? thumbnail;

    @_DBMediaFilesDisplayConverter()
    List<DBMediaFilesDisplay>? display;

    factory DBMediaFiles.fromJson(Map<String, dynamic> json) => _$DBMediaFilesFromJson(json);
    Map<String, dynamic> toJson() => _$DBMediaFilesToJson(this);
}
class _DBMediaFilesConverter extends TypeConverter<DBMediaFiles, String>{
  const _DBMediaFilesConverter();

  @override
  DBMediaFiles fromIsar(String object) {
    return DBMediaFiles.fromJson(jsonDecode(object));
  }

  @override
  String toIsar(DBMediaFiles object) {
    return jsonEncode(object.toJson());
  }
}


@JsonSerializable()
class DBMediaFilesDisplay {
    DBMediaFilesDisplay({
      required  this.size,
      required  this.mimetype,
      required  this.versionID,
    });

    int size;
    String mimetype;
    String versionID;

    factory DBMediaFilesDisplay.fromJson(Map<String, dynamic> json) => _$DBMediaFilesDisplayFromJson(json);
    Map<String, dynamic> toJson() => _$DBMediaFilesDisplayToJson(this);
}
class _DBMediaFilesDisplayConverter extends TypeConverter<DBMediaFilesDisplay, String>{
  const _DBMediaFilesDisplayConverter();

  @override
  DBMediaFilesDisplay fromIsar(String object) {
    return DBMediaFilesDisplay.fromJson(jsonDecode(object));
  }

  @override
  String toIsar(DBMediaFilesDisplay object) {
    return jsonEncode(object.toJson());
  }
}



@JsonSerializable()
class DBMediaFilesThumbnail {
    DBMediaFilesThumbnail({
       required this.size,
    });

    int size;

    factory DBMediaFilesThumbnail.fromJson(Map<String, dynamic> json) => _$DBMediaFilesThumbnailFromJson(json);
     Map<String, dynamic> toJson() => _$DBMediaFilesThumbnailToJson(this);
}
class _DBMediaFilesThumbnailConverter extends TypeConverter<DBMediaFilesThumbnail, String>{
  const _DBMediaFilesThumbnailConverter();

  @override
  DBMediaFilesThumbnail fromIsar(String object) {
    return DBMediaFilesThumbnail.fromJson(jsonDecode(object));
  }

  @override
  String toIsar(DBMediaFilesThumbnail object) {
    return jsonEncode(object.toJson());
  }
}



@JsonSerializable()
class DBMediaMetadata {
    DBMediaMetadata({
       required this.filename,
       required this.totalSize,
    });

    String filename;
    int totalSize;

     factory DBMediaMetadata.fromJson(Map<String, dynamic> json) => _$DBMediaMetadataFromJson(json);
     Map<String, dynamic> toJson() => _$DBMediaMetadataToJson(this);
}
class _DBMediaMetadataConverter extends TypeConverter<DBMediaMetadata, String>{
  const _DBMediaMetadataConverter();

  @override
  DBMediaMetadata fromIsar(String object) {
    return DBMediaMetadata.fromJson(jsonDecode(object));
  }

  @override
  String toIsar(DBMediaMetadata object) {
    return jsonEncode(object.toJson());
  }


}

