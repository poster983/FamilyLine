// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DBMedia.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetDBMediaCollection on Isar {
  IsarCollection<DBMedia> get dBMedias {
    return getCollection('DBMedia');
  }
}

final DBMediaSchema = CollectionSchema(
  name: 'DBMedia',
  schema:
      '{"name":"DBMedia","idName":"isarID","properties":[{"name":"blurhash","type":"String"},{"name":"encoding","type":"String"},{"name":"files","type":"String"},{"name":"groupID","type":"String"},{"name":"lastModified","type":"Long"},{"name":"metadata","type":"String"},{"name":"mongoID","type":"String"},{"name":"sortDate","type":"Long"},{"name":"type","type":"String"},{"name":"uploaded","type":"Long"}],"indexes":[],"links":[]}',
  nativeAdapter: const _DBMediaNativeAdapter(),
  webAdapter: const _DBMediaWebAdapter(),
  idName: 'isarID',
  propertyIds: {
    'blurhash': 0,
    'encoding': 1,
    'files': 2,
    'groupID': 3,
    'lastModified': 4,
    'metadata': 5,
    'mongoID': 6,
    'sortDate': 7,
    'type': 8,
    'uploaded': 9
  },
  listProperties: {},
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) {
    if (obj.isarID == Isar.autoIncrement) {
      return null;
    } else {
      return obj.isarID;
    }
  },
  setId: (obj, id) => obj.isarID = id,
  getLinks: (obj) => [],
  version: 2,
);

const _dBMedia_DBMediaEncodingConverter = _DBMediaEncodingConverter();
const _dBMedia_DBMediaFilesConverter = _DBMediaFilesConverter();
const _dBMedia_DBMediaMetadataConverter = _DBMediaMetadataConverter();

class _DBMediaWebAdapter extends IsarWebTypeAdapter<DBMedia> {
  const _DBMediaWebAdapter();

  @override
  Object serialize(IsarCollection<DBMedia> collection, DBMedia object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'blurhash', object.blurhash);
    IsarNative.jsObjectSet(jsObj, 'encoding',
        _dBMedia_DBMediaEncodingConverter.toIsar(object.encoding));
    IsarNative.jsObjectSet(
        jsObj, 'files', _dBMedia_DBMediaFilesConverter.toIsar(object.files));
    IsarNative.jsObjectSet(jsObj, 'groupID', object.groupID);
    IsarNative.jsObjectSet(jsObj, 'isarID', object.isarID);
    IsarNative.jsObjectSet(jsObj, 'lastModified',
        object.lastModified.toUtc().millisecondsSinceEpoch);
    IsarNative.jsObjectSet(jsObj, 'metadata',
        _dBMedia_DBMediaMetadataConverter.toIsar(object.metadata));
    IsarNative.jsObjectSet(jsObj, 'mongoID', object.mongoID);
    IsarNative.jsObjectSet(
        jsObj, 'sortDate', object.sortDate.toUtc().millisecondsSinceEpoch);
    IsarNative.jsObjectSet(jsObj, 'type', object.type);
    IsarNative.jsObjectSet(
        jsObj, 'uploaded', object.uploaded.toUtc().millisecondsSinceEpoch);
    return jsObj;
  }

  @override
  DBMedia deserialize(IsarCollection<DBMedia> collection, dynamic jsObj) {
    final object = DBMedia(
      blurhash: IsarNative.jsObjectGet(jsObj, 'blurhash'),
      files: _dBMedia_DBMediaFilesConverter
          .fromIsar(IsarNative.jsObjectGet(jsObj, 'files') ?? ''),
      groupID: IsarNative.jsObjectGet(jsObj, 'groupID') ?? '',
      isarID: IsarNative.jsObjectGet(jsObj, 'isarID'),
      lastModified: IsarNative.jsObjectGet(jsObj, 'lastModified') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'lastModified'),
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0),
      metadata: _dBMedia_DBMediaMetadataConverter
          .fromIsar(IsarNative.jsObjectGet(jsObj, 'metadata') ?? ''),
      mongoID: IsarNative.jsObjectGet(jsObj, 'mongoID') ?? '',
      sortDate: IsarNative.jsObjectGet(jsObj, 'sortDate') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'sortDate'),
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0),
      type: IsarNative.jsObjectGet(jsObj, 'type') ?? '',
      uploaded: IsarNative.jsObjectGet(jsObj, 'uploaded') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'uploaded'),
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
    object.encoding = _dBMedia_DBMediaEncodingConverter
        .fromIsar(IsarNative.jsObjectGet(jsObj, 'encoding') ?? '');
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'blurhash':
        return (IsarNative.jsObjectGet(jsObj, 'blurhash')) as P;
      case 'encoding':
        return (_dBMedia_DBMediaEncodingConverter
            .fromIsar(IsarNative.jsObjectGet(jsObj, 'encoding') ?? '')) as P;
      case 'files':
        return (_dBMedia_DBMediaFilesConverter
            .fromIsar(IsarNative.jsObjectGet(jsObj, 'files') ?? '')) as P;
      case 'groupID':
        return (IsarNative.jsObjectGet(jsObj, 'groupID') ?? '') as P;
      case 'isarID':
        return (IsarNative.jsObjectGet(jsObj, 'isarID')) as P;
      case 'lastModified':
        return (IsarNative.jsObjectGet(jsObj, 'lastModified') != null
            ? DateTime.fromMillisecondsSinceEpoch(
                    IsarNative.jsObjectGet(jsObj, 'lastModified'),
                    isUtc: true)
                .toLocal()
            : DateTime.fromMillisecondsSinceEpoch(0)) as P;
      case 'metadata':
        return (_dBMedia_DBMediaMetadataConverter
            .fromIsar(IsarNative.jsObjectGet(jsObj, 'metadata') ?? '')) as P;
      case 'mongoID':
        return (IsarNative.jsObjectGet(jsObj, 'mongoID') ?? '') as P;
      case 'sortDate':
        return (IsarNative.jsObjectGet(jsObj, 'sortDate') != null
            ? DateTime.fromMillisecondsSinceEpoch(
                    IsarNative.jsObjectGet(jsObj, 'sortDate'),
                    isUtc: true)
                .toLocal()
            : DateTime.fromMillisecondsSinceEpoch(0)) as P;
      case 'type':
        return (IsarNative.jsObjectGet(jsObj, 'type') ?? '') as P;
      case 'uploaded':
        return (IsarNative.jsObjectGet(jsObj, 'uploaded') != null
            ? DateTime.fromMillisecondsSinceEpoch(
                    IsarNative.jsObjectGet(jsObj, 'uploaded'),
                    isUtc: true)
                .toLocal()
            : DateTime.fromMillisecondsSinceEpoch(0)) as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, DBMedia object) {}
}

class _DBMediaNativeAdapter extends IsarNativeTypeAdapter<DBMedia> {
  const _DBMediaNativeAdapter();

  @override
  void serialize(IsarCollection<DBMedia> collection, IsarRawObject rawObj,
      DBMedia object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.blurhash;
    IsarUint8List? _blurhash;
    if (value0 != null) {
      _blurhash = IsarBinaryWriter.utf8Encoder.convert(value0);
    }
    dynamicSize += (_blurhash?.length ?? 0) as int;
    final value1 = _dBMedia_DBMediaEncodingConverter.toIsar(object.encoding);
    final _encoding = IsarBinaryWriter.utf8Encoder.convert(value1);
    dynamicSize += (_encoding.length) as int;
    final value2 = _dBMedia_DBMediaFilesConverter.toIsar(object.files);
    final _files = IsarBinaryWriter.utf8Encoder.convert(value2);
    dynamicSize += (_files.length) as int;
    final value3 = object.groupID;
    final _groupID = IsarBinaryWriter.utf8Encoder.convert(value3);
    dynamicSize += (_groupID.length) as int;
    final value4 = object.lastModified;
    final _lastModified = value4;
    final value5 = _dBMedia_DBMediaMetadataConverter.toIsar(object.metadata);
    final _metadata = IsarBinaryWriter.utf8Encoder.convert(value5);
    dynamicSize += (_metadata.length) as int;
    final value6 = object.mongoID;
    final _mongoID = IsarBinaryWriter.utf8Encoder.convert(value6);
    dynamicSize += (_mongoID.length) as int;
    final value7 = object.sortDate;
    final _sortDate = value7;
    final value8 = object.type;
    final _type = IsarBinaryWriter.utf8Encoder.convert(value8);
    dynamicSize += (_type.length) as int;
    final value9 = object.uploaded;
    final _uploaded = value9;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBytes(offsets[0], _blurhash);
    writer.writeBytes(offsets[1], _encoding);
    writer.writeBytes(offsets[2], _files);
    writer.writeBytes(offsets[3], _groupID);
    writer.writeDateTime(offsets[4], _lastModified);
    writer.writeBytes(offsets[5], _metadata);
    writer.writeBytes(offsets[6], _mongoID);
    writer.writeDateTime(offsets[7], _sortDate);
    writer.writeBytes(offsets[8], _type);
    writer.writeDateTime(offsets[9], _uploaded);
  }

  @override
  DBMedia deserialize(IsarCollection<DBMedia> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = DBMedia(
      blurhash: reader.readStringOrNull(offsets[0]),
      files: _dBMedia_DBMediaFilesConverter
          .fromIsar(reader.readString(offsets[2])),
      groupID: reader.readString(offsets[3]),
      isarID: id,
      lastModified: reader.readDateTime(offsets[4]),
      metadata: _dBMedia_DBMediaMetadataConverter
          .fromIsar(reader.readString(offsets[5])),
      mongoID: reader.readString(offsets[6]),
      sortDate: reader.readDateTime(offsets[7]),
      type: reader.readString(offsets[8]),
      uploaded: reader.readDateTime(offsets[9]),
    );
    object.encoding = _dBMedia_DBMediaEncodingConverter
        .fromIsar(reader.readString(offsets[1]));
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readStringOrNull(offset)) as P;
      case 1:
        return (_dBMedia_DBMediaEncodingConverter
            .fromIsar(reader.readString(offset))) as P;
      case 2:
        return (_dBMedia_DBMediaFilesConverter
            .fromIsar(reader.readString(offset))) as P;
      case 3:
        return (reader.readString(offset)) as P;
      case 4:
        return (reader.readDateTime(offset)) as P;
      case 5:
        return (_dBMedia_DBMediaMetadataConverter
            .fromIsar(reader.readString(offset))) as P;
      case 6:
        return (reader.readString(offset)) as P;
      case 7:
        return (reader.readDateTime(offset)) as P;
      case 8:
        return (reader.readString(offset)) as P;
      case 9:
        return (reader.readDateTime(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, DBMedia object) {}
}

extension DBMediaQueryWhereSort on QueryBuilder<DBMedia, DBMedia, QWhere> {
  QueryBuilder<DBMedia, DBMedia, QAfterWhere> anyIsarID() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension DBMediaQueryWhere on QueryBuilder<DBMedia, DBMedia, QWhereClause> {
  QueryBuilder<DBMedia, DBMedia, QAfterWhereClause> isarIDEqualTo(int? isarID) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [isarID],
      includeLower: true,
      upper: [isarID],
      includeUpper: true,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterWhereClause> isarIDNotEqualTo(
      int? isarID) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [isarID],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [isarID],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [isarID],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [isarID],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<DBMedia, DBMedia, QAfterWhereClause> isarIDGreaterThan(
    int? isarID, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [isarID],
      includeLower: include,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterWhereClause> isarIDLessThan(
    int? isarID, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [isarID],
      includeUpper: include,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterWhereClause> isarIDBetween(
    int? lowerIsarID,
    int? upperIsarID, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerIsarID],
      includeLower: includeLower,
      upper: [upperIsarID],
      includeUpper: includeUpper,
    ));
  }
}

extension DBMediaQueryFilter
    on QueryBuilder<DBMedia, DBMedia, QFilterCondition> {
  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> blurhashIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'blurhash',
      value: null,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> blurhashEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'blurhash',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> blurhashGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'blurhash',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> blurhashLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'blurhash',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> blurhashBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'blurhash',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> blurhashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'blurhash',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> blurhashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'blurhash',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> blurhashContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'blurhash',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> blurhashMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'blurhash',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> encodingEqualTo(
    DBMediaEncoding? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'encoding',
      value: _dBMedia_DBMediaEncodingConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> encodingGreaterThan(
    DBMediaEncoding? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'encoding',
      value: _dBMedia_DBMediaEncodingConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> encodingLessThan(
    DBMediaEncoding? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'encoding',
      value: _dBMedia_DBMediaEncodingConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> encodingBetween(
    DBMediaEncoding? lower,
    DBMediaEncoding? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'encoding',
      lower: _dBMedia_DBMediaEncodingConverter.toIsar(lower),
      includeLower: includeLower,
      upper: _dBMedia_DBMediaEncodingConverter.toIsar(upper),
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> encodingStartsWith(
    DBMediaEncoding value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'encoding',
      value: _dBMedia_DBMediaEncodingConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> encodingEndsWith(
    DBMediaEncoding value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'encoding',
      value: _dBMedia_DBMediaEncodingConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> encodingContains(
      DBMediaEncoding value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'encoding',
      value: _dBMedia_DBMediaEncodingConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> encodingMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'encoding',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> filesEqualTo(
    DBMediaFiles value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'files',
      value: _dBMedia_DBMediaFilesConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> filesGreaterThan(
    DBMediaFiles value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'files',
      value: _dBMedia_DBMediaFilesConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> filesLessThan(
    DBMediaFiles value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'files',
      value: _dBMedia_DBMediaFilesConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> filesBetween(
    DBMediaFiles lower,
    DBMediaFiles upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'files',
      lower: _dBMedia_DBMediaFilesConverter.toIsar(lower),
      includeLower: includeLower,
      upper: _dBMedia_DBMediaFilesConverter.toIsar(upper),
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> filesStartsWith(
    DBMediaFiles value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'files',
      value: _dBMedia_DBMediaFilesConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> filesEndsWith(
    DBMediaFiles value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'files',
      value: _dBMedia_DBMediaFilesConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> filesContains(
      DBMediaFiles value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'files',
      value: _dBMedia_DBMediaFilesConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> filesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'files',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> groupIDEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'groupID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> groupIDGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'groupID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> groupIDLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'groupID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> groupIDBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'groupID',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> groupIDStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'groupID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> groupIDEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'groupID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> groupIDContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'groupID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> groupIDMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'groupID',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> isarIDIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'isarID',
      value: null,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> isarIDEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isarID',
      value: value,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> isarIDGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'isarID',
      value: value,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> isarIDLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'isarID',
      value: value,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> isarIDBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'isarID',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> lastModifiedEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'lastModified',
      value: value,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> lastModifiedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'lastModified',
      value: value,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> lastModifiedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'lastModified',
      value: value,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> lastModifiedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'lastModified',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> metadataEqualTo(
    DBMediaMetadata value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'metadata',
      value: _dBMedia_DBMediaMetadataConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> metadataGreaterThan(
    DBMediaMetadata value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'metadata',
      value: _dBMedia_DBMediaMetadataConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> metadataLessThan(
    DBMediaMetadata value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'metadata',
      value: _dBMedia_DBMediaMetadataConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> metadataBetween(
    DBMediaMetadata lower,
    DBMediaMetadata upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'metadata',
      lower: _dBMedia_DBMediaMetadataConverter.toIsar(lower),
      includeLower: includeLower,
      upper: _dBMedia_DBMediaMetadataConverter.toIsar(upper),
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> metadataStartsWith(
    DBMediaMetadata value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'metadata',
      value: _dBMedia_DBMediaMetadataConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> metadataEndsWith(
    DBMediaMetadata value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'metadata',
      value: _dBMedia_DBMediaMetadataConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> metadataContains(
      DBMediaMetadata value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'metadata',
      value: _dBMedia_DBMediaMetadataConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> metadataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'metadata',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> mongoIDEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'mongoID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> mongoIDGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'mongoID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> mongoIDLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'mongoID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> mongoIDBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'mongoID',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> mongoIDStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'mongoID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> mongoIDEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'mongoID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> mongoIDContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'mongoID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> mongoIDMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'mongoID',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> sortDateEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'sortDate',
      value: value,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> sortDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'sortDate',
      value: value,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> sortDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'sortDate',
      value: value,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> sortDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'sortDate',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> typeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> typeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'type',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'type',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> uploadedEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'uploaded',
      value: value,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> uploadedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'uploaded',
      value: value,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> uploadedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'uploaded',
      value: value,
    ));
  }

  QueryBuilder<DBMedia, DBMedia, QAfterFilterCondition> uploadedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'uploaded',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension DBMediaQueryLinks
    on QueryBuilder<DBMedia, DBMedia, QFilterCondition> {}

extension DBMediaQueryWhereSortBy on QueryBuilder<DBMedia, DBMedia, QSortBy> {
  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByBlurhash() {
    return addSortByInternal('blurhash', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByBlurhashDesc() {
    return addSortByInternal('blurhash', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByEncoding() {
    return addSortByInternal('encoding', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByEncodingDesc() {
    return addSortByInternal('encoding', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByFiles() {
    return addSortByInternal('files', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByFilesDesc() {
    return addSortByInternal('files', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByGroupID() {
    return addSortByInternal('groupID', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByGroupIDDesc() {
    return addSortByInternal('groupID', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByIsarID() {
    return addSortByInternal('isarID', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByIsarIDDesc() {
    return addSortByInternal('isarID', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByLastModified() {
    return addSortByInternal('lastModified', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByLastModifiedDesc() {
    return addSortByInternal('lastModified', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByMetadata() {
    return addSortByInternal('metadata', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByMetadataDesc() {
    return addSortByInternal('metadata', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByMongoID() {
    return addSortByInternal('mongoID', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByMongoIDDesc() {
    return addSortByInternal('mongoID', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortBySortDate() {
    return addSortByInternal('sortDate', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortBySortDateDesc() {
    return addSortByInternal('sortDate', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByUploaded() {
    return addSortByInternal('uploaded', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> sortByUploadedDesc() {
    return addSortByInternal('uploaded', Sort.desc);
  }
}

extension DBMediaQueryWhereSortThenBy
    on QueryBuilder<DBMedia, DBMedia, QSortThenBy> {
  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByBlurhash() {
    return addSortByInternal('blurhash', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByBlurhashDesc() {
    return addSortByInternal('blurhash', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByEncoding() {
    return addSortByInternal('encoding', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByEncodingDesc() {
    return addSortByInternal('encoding', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByFiles() {
    return addSortByInternal('files', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByFilesDesc() {
    return addSortByInternal('files', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByGroupID() {
    return addSortByInternal('groupID', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByGroupIDDesc() {
    return addSortByInternal('groupID', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByIsarID() {
    return addSortByInternal('isarID', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByIsarIDDesc() {
    return addSortByInternal('isarID', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByLastModified() {
    return addSortByInternal('lastModified', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByLastModifiedDesc() {
    return addSortByInternal('lastModified', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByMetadata() {
    return addSortByInternal('metadata', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByMetadataDesc() {
    return addSortByInternal('metadata', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByMongoID() {
    return addSortByInternal('mongoID', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByMongoIDDesc() {
    return addSortByInternal('mongoID', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenBySortDate() {
    return addSortByInternal('sortDate', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenBySortDateDesc() {
    return addSortByInternal('sortDate', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByUploaded() {
    return addSortByInternal('uploaded', Sort.asc);
  }

  QueryBuilder<DBMedia, DBMedia, QAfterSortBy> thenByUploadedDesc() {
    return addSortByInternal('uploaded', Sort.desc);
  }
}

extension DBMediaQueryWhereDistinct
    on QueryBuilder<DBMedia, DBMedia, QDistinct> {
  QueryBuilder<DBMedia, DBMedia, QDistinct> distinctByBlurhash(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('blurhash', caseSensitive: caseSensitive);
  }

  QueryBuilder<DBMedia, DBMedia, QDistinct> distinctByEncoding(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('encoding', caseSensitive: caseSensitive);
  }

  QueryBuilder<DBMedia, DBMedia, QDistinct> distinctByFiles(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('files', caseSensitive: caseSensitive);
  }

  QueryBuilder<DBMedia, DBMedia, QDistinct> distinctByGroupID(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('groupID', caseSensitive: caseSensitive);
  }

  QueryBuilder<DBMedia, DBMedia, QDistinct> distinctByIsarID() {
    return addDistinctByInternal('isarID');
  }

  QueryBuilder<DBMedia, DBMedia, QDistinct> distinctByLastModified() {
    return addDistinctByInternal('lastModified');
  }

  QueryBuilder<DBMedia, DBMedia, QDistinct> distinctByMetadata(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('metadata', caseSensitive: caseSensitive);
  }

  QueryBuilder<DBMedia, DBMedia, QDistinct> distinctByMongoID(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('mongoID', caseSensitive: caseSensitive);
  }

  QueryBuilder<DBMedia, DBMedia, QDistinct> distinctBySortDate() {
    return addDistinctByInternal('sortDate');
  }

  QueryBuilder<DBMedia, DBMedia, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('type', caseSensitive: caseSensitive);
  }

  QueryBuilder<DBMedia, DBMedia, QDistinct> distinctByUploaded() {
    return addDistinctByInternal('uploaded');
  }
}

extension DBMediaQueryProperty
    on QueryBuilder<DBMedia, DBMedia, QQueryProperty> {
  QueryBuilder<DBMedia, String?, QQueryOperations> blurhashProperty() {
    return addPropertyNameInternal('blurhash');
  }

  QueryBuilder<DBMedia, DBMediaEncoding?, QQueryOperations> encodingProperty() {
    return addPropertyNameInternal('encoding');
  }

  QueryBuilder<DBMedia, DBMediaFiles, QQueryOperations> filesProperty() {
    return addPropertyNameInternal('files');
  }

  QueryBuilder<DBMedia, String, QQueryOperations> groupIDProperty() {
    return addPropertyNameInternal('groupID');
  }

  QueryBuilder<DBMedia, int?, QQueryOperations> isarIDProperty() {
    return addPropertyNameInternal('isarID');
  }

  QueryBuilder<DBMedia, DateTime, QQueryOperations> lastModifiedProperty() {
    return addPropertyNameInternal('lastModified');
  }

  QueryBuilder<DBMedia, DBMediaMetadata, QQueryOperations> metadataProperty() {
    return addPropertyNameInternal('metadata');
  }

  QueryBuilder<DBMedia, String, QQueryOperations> mongoIDProperty() {
    return addPropertyNameInternal('mongoID');
  }

  QueryBuilder<DBMedia, DateTime, QQueryOperations> sortDateProperty() {
    return addPropertyNameInternal('sortDate');
  }

  QueryBuilder<DBMedia, String, QQueryOperations> typeProperty() {
    return addPropertyNameInternal('type');
  }

  QueryBuilder<DBMedia, DateTime, QQueryOperations> uploadedProperty() {
    return addPropertyNameInternal('uploaded');
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DBMedia _$DBMediaFromJson(Map<String, dynamic> json) => DBMedia(
      metadata:
          DBMediaMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      files: DBMediaFiles.fromJson(json['files'] as Map<String, dynamic>),
      isarID: json['isarID'] as int?,
      mongoID: json['_id'] as String,
      groupID: json['groupID'] as String,
      type: json['type'] as String,
      uploaded: DateTime.parse(json['uploaded'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
      sortDate: DateTime.parse(json['sortDate'] as String),
      blurhash: json['blurhash'] as String?,
    )..encoding = json['encoding'] == null
        ? null
        : DBMediaEncoding.fromJson(json['encoding'] as Map<String, dynamic>);

Map<String, dynamic> _$DBMediaToJson(DBMedia instance) => <String, dynamic>{
      'isarID': instance.isarID,
      '_id': instance.mongoID,
      'encoding': instance.encoding,
      'metadata': instance.metadata,
      'files': instance.files,
      'groupID': instance.groupID,
      'type': instance.type,
      'uploaded': instance.uploaded.toIso8601String(),
      'lastModified': instance.lastModified.toIso8601String(),
      'sortDate': instance.sortDate.toIso8601String(),
      'blurhash': instance.blurhash,
    };

DBMediaEncoding _$DBMediaEncodingFromJson(Map<String, dynamic> json) =>
    DBMediaEncoding(
      progress: (json['progress'] as num).toDouble(),
      started: json['started'] == null
          ? null
          : DateTime.parse(json['started'] as String),
      finished: json['finished'] == null
          ? null
          : DateTime.parse(json['finished'] as String),
    );

Map<String, dynamic> _$DBMediaEncodingToJson(DBMediaEncoding instance) =>
    <String, dynamic>{
      'progress': instance.progress,
      'started': instance.started?.toIso8601String(),
      'finished': instance.finished?.toIso8601String(),
    };

DBMediaFiles _$DBMediaFilesFromJson(Map<String, dynamic> json) => DBMediaFiles(
      thumbnail: json['thumbnail'] == null
          ? null
          : DBMediaFilesThumbnail.fromJson(
              json['thumbnail'] as Map<String, dynamic>),
      display: (json['display'] as List<dynamic>?)
          ?.map((e) => DBMediaFilesDisplay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DBMediaFilesToJson(DBMediaFiles instance) =>
    <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'display': instance.display,
    };

DBMediaFilesDisplay _$DBMediaFilesDisplayFromJson(Map<String, dynamic> json) =>
    DBMediaFilesDisplay(
      size: json['size'] as int,
      mimetype: json['mimetype'] as String,
      versionID: json['versionID'] as String,
    );

Map<String, dynamic> _$DBMediaFilesDisplayToJson(
        DBMediaFilesDisplay instance) =>
    <String, dynamic>{
      'size': instance.size,
      'mimetype': instance.mimetype,
      'versionID': instance.versionID,
    };

DBMediaFilesThumbnail _$DBMediaFilesThumbnailFromJson(
        Map<String, dynamic> json) =>
    DBMediaFilesThumbnail(
      size: json['size'] as int,
    );

Map<String, dynamic> _$DBMediaFilesThumbnailToJson(
        DBMediaFilesThumbnail instance) =>
    <String, dynamic>{
      'size': instance.size,
    };

DBMediaMetadata _$DBMediaMetadataFromJson(Map<String, dynamic> json) =>
    DBMediaMetadata(
      filename: json['filename'] as String,
      totalSize: json['totalSize'] as int,
    );

Map<String, dynamic> _$DBMediaMetadataToJson(DBMediaMetadata instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      'totalSize': instance.totalSize,
    };
