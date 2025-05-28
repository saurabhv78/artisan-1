// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artist_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ArtistPageState {
  List<ProductData>? get popularProducts => throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;
  ArtistPageStatus get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ArtistPageStateCopyWith<ArtistPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArtistPageStateCopyWith<$Res> {
  factory $ArtistPageStateCopyWith(
          ArtistPageState value, $Res Function(ArtistPageState) then) =
      _$ArtistPageStateCopyWithImpl<$Res, ArtistPageState>;
  @useResult
  $Res call(
      {List<ProductData>? popularProducts,
      String errorMessage,
      ArtistPageStatus status});
}

/// @nodoc
class _$ArtistPageStateCopyWithImpl<$Res, $Val extends ArtistPageState>
    implements $ArtistPageStateCopyWith<$Res> {
  _$ArtistPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? popularProducts = freezed,
    Object? errorMessage = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      popularProducts: freezed == popularProducts
          ? _value.popularProducts
          : popularProducts // ignore: cast_nullable_to_non_nullable
              as List<ProductData>?,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ArtistPageStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArtistPageStateImplCopyWith<$Res>
    implements $ArtistPageStateCopyWith<$Res> {
  factory _$$ArtistPageStateImplCopyWith(_$ArtistPageStateImpl value,
          $Res Function(_$ArtistPageStateImpl) then) =
      __$$ArtistPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ProductData>? popularProducts,
      String errorMessage,
      ArtistPageStatus status});
}

/// @nodoc
class __$$ArtistPageStateImplCopyWithImpl<$Res>
    extends _$ArtistPageStateCopyWithImpl<$Res, _$ArtistPageStateImpl>
    implements _$$ArtistPageStateImplCopyWith<$Res> {
  __$$ArtistPageStateImplCopyWithImpl(
      _$ArtistPageStateImpl _value, $Res Function(_$ArtistPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? popularProducts = freezed,
    Object? errorMessage = null,
    Object? status = null,
  }) {
    return _then(_$ArtistPageStateImpl(
      popularProducts: freezed == popularProducts
          ? _value._popularProducts
          : popularProducts // ignore: cast_nullable_to_non_nullable
              as List<ProductData>?,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ArtistPageStatus,
    ));
  }
}

/// @nodoc

class _$ArtistPageStateImpl implements _ArtistPageState {
  const _$ArtistPageStateImpl(
      {final List<ProductData>? popularProducts = null,
      this.errorMessage = '',
      this.status = ArtistPageStatus.initial})
      : _popularProducts = popularProducts;

  final List<ProductData>? _popularProducts;
  @override
  @JsonKey()
  List<ProductData>? get popularProducts {
    final value = _popularProducts;
    if (value == null) return null;
    if (_popularProducts is EqualUnmodifiableListView) return _popularProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final String errorMessage;
  @override
  @JsonKey()
  final ArtistPageStatus status;

  @override
  String toString() {
    return 'ArtistPageState(popularProducts: $popularProducts, errorMessage: $errorMessage, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArtistPageStateImpl &&
            const DeepCollectionEquality()
                .equals(other._popularProducts, _popularProducts) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_popularProducts),
      errorMessage,
      status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ArtistPageStateImplCopyWith<_$ArtistPageStateImpl> get copyWith =>
      __$$ArtistPageStateImplCopyWithImpl<_$ArtistPageStateImpl>(
          this, _$identity);
}

abstract class _ArtistPageState implements ArtistPageState {
  const factory _ArtistPageState(
      {final List<ProductData>? popularProducts,
      final String errorMessage,
      final ArtistPageStatus status}) = _$ArtistPageStateImpl;

  @override
  List<ProductData>? get popularProducts;
  @override
  String get errorMessage;
  @override
  ArtistPageStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$ArtistPageStateImplCopyWith<_$ArtistPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
