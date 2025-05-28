// // ignore_for_file: public_member_api_docs, sort_constructors_first

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../logic/api_services/api_service.dart';
// import '../../models/api_response.dart';
// import '../../utils/network_utils.dart';
// part 'main_page_model.freezed.dart';

// final mainPageModelProvider =
//     StateNotifierProvider.autoDispose<MainPageModel, MainPageState>(
//   (ref) => MainPageModel(
//     ref: ref,
//     apiService: ref.read(apiServiceProvider),
//   ),
// );

// class MainPageModel extends StateNotifier<MainPageState> {
//   final ApiService apiService;
//   final StateNotifierProviderRef ref;

//   MainPageModel({
//     required this.apiService,
//     required this.ref,
//   }) : super(const MainPageState());
// }

// @freezed
// class MainPageState with _$MainPageState {
//   const factory MainPageState() = _MainPageState;
// }
