// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProductPageState {
  List<ProductData>? get moreByArtist => throw _privateConstructorUsedError;
  ProductData? get productData => throw _privateConstructorUsedError;
  List<String> get id => throw _privateConstructorUsedError;
  String get errMessage => throw _privateConstructorUsedError;
  ProductPageStatus get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProductPageStateCopyWith<ProductPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductPageStateCopyWith<$Res> {
  factory $ProductPageStateCopyWith(
          ProductPageState value, $Res Function(ProductPageState) then) =
      _$ProductPageStateCopyWithImpl<$Res, ProductPageState>;
  @useResult
  $Res call(
      {List<ProductData>? moreByArtist,
      ProductData? productData,
      List<String> id,
      String errMessage,
      ProductPageStatus status});
}

/// @nodoc
class _$ProductPageStateCopyWithImpl<$Res, $Val extends ProductPageState>
    implements $ProductPageStateCopyWith<$Res> {
  _$ProductPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moreByArtist = freezed,
    Object? productData = freezed,
    Object? id = null,
    Object? errMessage = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      moreByArtist: freezed == moreByArtist
          ? _value.moreByArtist
          : moreByArtist // ignore: cast_nullable_to_non_nullable
              as List<ProductData>?,
      productData: freezed == productData
          ? _value.productData
          : productData // ignore: cast_nullable_to_non_nullable
              as ProductData?,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as List<String>,
      errMessage: null == errMessage
          ? _value.errMessage
          : errMessage // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProductPageStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductPageStateImplCopyWith<$Res>
    implements $ProductPageStateCopyWith<$Res> {
  factory _$$ProductPageStateImplCopyWith(_$ProductPageStateImpl value,
          $Res Function(_$ProductPageStateImpl) then) =
      __$$ProductPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ProductData>? moreByArtist,
      ProductData? productData,
      List<String> id,
      String errMessage,
      ProductPageStatus status});
}

/// @nodoc
class __$$ProductPageStateImplCopyWithImpl<$Res>
    extends _$ProductPageStateCopyWithImpl<$Res, _$ProductPageStateImpl>
    implements _$$ProductPageStateImplCopyWith<$Res> {
  __$$ProductPageStateImplCopyWithImpl(_$ProductPageStateImpl _value,
      $Res Function(_$ProductPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moreByArtist = freezed,
    Object? productData = freezed,
    Object? id = null,
    Object? errMessage = null,
    Object? status = null,
  }) {
    return _then(_$ProductPageStateImpl(
      moreByArtist: freezed == moreByArtist
          ? _value._moreByArtist
          : moreByArtist // ignore: cast_nullable_to_non_nullable
              as List<ProductData>?,
      productData: freezed == productData
          ? _value.productData
          : productData // ignore: cast_nullable_to_non_nullable
              as ProductData?,
      id: null == id
          ? _value._id
          : id // ignore: cast_nullable_to_non_nullable
              as List<String>,
      errMessage: null == errMessage
          ? _value.errMessage
          : errMessage // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProductPageStatus,
    ));
  }
}

/// @nodoc

class _$ProductPageStateImpl implements _ProductPageState {
  const _$ProductPageStateImpl(
      {final List<ProductData>? moreByArtist = null,
      this.productData = null,
      final List<String> id = const [],
      this.errMessage = '',
      this.status = ProductPageStatus.initial})
      : _moreByArtist = moreByArtist,
        _id = id;

  final List<ProductData>? _moreByArtist;
  @override
  @JsonKey()
  List<ProductData>? get moreByArtist {
    final value = _moreByArtist;
    if (value == null) return null;
    if (_moreByArtist is EqualUnmodifiableListView) return _moreByArtist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final ProductData? productData;
  final List<String> _id;
  @override
  @JsonKey()
  List<String> get id {
    if (_id is EqualUnmodifiableListView) return _id;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_id);
  }

  @override
  @JsonKey()
  final String errMessage;
  @override
  @JsonKey()
  final ProductPageStatus status;

  @override
  String toString() {
    return 'ProductPageState(moreByArtist: $moreByArtist, productData: $productData, id: $id, errMessage: $errMessage, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductPageStateImpl &&
            const DeepCollectionEquality()
                .equals(other._moreByArtist, _moreByArtist) &&
            (identical(other.productData, productData) ||
                other.productData == productData) &&
            const DeepCollectionEquality().equals(other._id, _id) &&
            (identical(other.errMessage, errMessage) ||
                other.errMessage == errMessage) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_moreByArtist),
      productData,
      const DeepCollectionEquality().hash(_id),
      errMessage,
      status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductPageStateImplCopyWith<_$ProductPageStateImpl> get copyWith =>
      __$$ProductPageStateImplCopyWithImpl<_$ProductPageStateImpl>(
          this, _$identity);
}

abstract class _ProductPageState implements ProductPageState {
  const factory _ProductPageState(
      {final List<ProductData>? moreByArtist,
      final ProductData? productData,
      final List<String> id,
      final String errMessage,
      final ProductPageStatus status}) = _$ProductPageStateImpl;

  @override
  List<ProductData>? get moreByArtist;
  @override
  ProductData? get productData;
  @override
  List<String> get id;
  @override
  String get errMessage;
  @override
  ProductPageStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$ProductPageStateImplCopyWith<_$ProductPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
