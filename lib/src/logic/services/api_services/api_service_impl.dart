// 📦 Package imports:

// 🌎 Project imports:

import 'dart:developer';

import 'package:Artisan/src/logic/services/api_services/retrofit/basic_api_client/basic_api_client.dart';
import 'package:Artisan/src/models/artist_data/artist_data.dart';
import 'package:Artisan/src/models/artstyle_data/art_style_data.dart';
import 'package:Artisan/src/models/cart_data/cart_data.dart';
import 'package:Artisan/src/models/category_data/category_data.dart';
import 'package:Artisan/src/models/discount_data/discount_data.dart';
import 'package:Artisan/src/models/requests/cart_product_data/cart_product_data.dart';
import 'package:Artisan/src/models/requests/get_list_data_request.dart';
import 'package:Artisan/src/models/requests/refresh_token_request.dart';
import 'package:Artisan/src/models/requests/send_email_otp_request.dart';
import 'package:Artisan/src/models/requests/user_login_request.dart';
import 'package:Artisan/src/models/requests/user_logout_request.dart';
import 'package:Artisan/src/models/user_data.dart';
import 'package:Artisan/src/models/user_register_data.dart';
import 'package:dio/dio.dart';

import '../../../models/api_response.dart';
import '../../../models/product_data/featured_product.dart';
import '../../../models/product_data/product_data.dart';
import '../../../models/requests/social_login_request.dart';
import '../../../models/wishlist_product_data/wishlist_product_data.dart';
import '../../../utils/network_utils.dart';
import 'api_service.dart';
import 'retrofit/auth_api_client/auth_api_client.dart';

class ApiServiceImpl extends ApiService {
  late final Dio dio;
  late final AuthApiClient _authApiClient;
  late final BasicApiClient _basicApiClient;
  late final String baseUrl;

  ApiServiceImpl() {
    dio = Dio(
      BaseOptions(connectTimeout: const Duration(milliseconds: 200000)),
    );
    _authApiClient = AuthApiClient(dio);
    _basicApiClient = BasicApiClient(dio);
  }

  @override
  Future<ApiResponse<UserData>> registerUser({
    required UserRegisterData userData,
  }) async {
    return await safeApiCall<UserData>(
      () async => await _authApiClient.registerUser(userRegisterData: userData),
      (response) => ApiResponse.success(UserData.fromJson(response['data'])),
    );
  }

  @override
  Future<ApiResponse<UserData>> loginUser({
    required UserLoginRequest userLoginRequest,
  }) async {
    return await safeApiCall<UserData>(
      () async =>
          await _authApiClient.loginUser(userLoginRequest: userLoginRequest),
      (response) =>
          ApiResponse<UserData>.success(UserData.fromJson(response['data'])),
    );
  }

  @override
  Future<ApiResponse<String>> sendOtp({
    required String token,
    required SendEmailOtpRequest sendEmailOtpRequest,
  }) async {
    return await safeApiCall<String>(
      () async => await _authApiClient.sendEmailOtp(
          token: token, sendEmailOtpRequest: sendEmailOtpRequest),
      (response) => ApiResponse.success(response['message']),
    );
  }

  @override
  Future<ApiResponse<String>> updateEmailOtp({
    required String token,
    required SendEmailOtpRequest sendEmailOtpRequest,
  }) async {
    return await safeApiCall<String>(
      () async => await _authApiClient.updateEmailOtp(
          token: token, sendEmailOtpRequest: sendEmailOtpRequest),
      (response) => ApiResponse.success(""),
    );
  }

  @override
  Future<ApiResponse<String>> verifyOtp({
    required SendEmailOtpRequest sendEmailOtpRequest,
  }) async {
    try {
      final response = await _authApiClient.verifyOtp(
          sendEmailOtpRequest: sendEmailOtpRequest) as Map<String, dynamic>;
      if (response['success'] == false) {
        return ApiResponse.error(
            response['message'] ?? "Something Went Wrong!");
      } else if (response['success'] == true) {
        return ApiResponse.success("");
      } else {
        return ApiResponse.error('Something Went Wrong');
      }
    } on DioException catch (e) {
      final hasInternet = await hasInternetAccess();
      if (!hasInternet) {
        return ApiResponse.noInternet();
      }
      return ApiResponse.error(
          e.response?.data['message'] ?? "Something Went Wrong!!!");
    }
  }

  @override
  Future<ApiResponse<UserLoggedData>> fetchUserDetails({
    required String token,
  }) async {
    return await safeApiCall<UserLoggedData>(
      () async => await _authApiClient.fetchUserDetails(token: token),
      (response) => ApiResponse<UserLoggedData>.success(
          UserLoggedData.fromJson(response['data'])),
    );
  }

  @override
  Future<ApiResponse<UserData>> socialLogin({
    required SocialLoginRequest socialLoginRequest,
  }) async {
    try {
      final response = await _authApiClient.soicalLogin(
        socialLoginRequest: socialLoginRequest,
      ) as Map<String, dynamic>;

      if (response['success'] == false) {
        return ApiResponse<UserData>.error(
            response['message'] ?? "Something Went Wrong!");
      }

      return ApiResponse<UserData>.success(UserData.fromJson(response['data']));
    } on DioException catch (e) {
      final hasInternet = await hasInternetAccess();
      if (!hasInternet) {
        return ApiResponse<UserData>.noInternet();
      }
      if (e.response?.data['message'].runtimeType.toString() ==
          "_Map<String, dynamic>") {
        return ApiResponse.error("Server did not respond. Try Again!!!");
      }
      return ApiResponse<UserData>.error(
          e.response?.data['message'] ?? "Something Went Wrong");
    }
  }

  @override
  Future<ApiResponse<String>> sendForgotPassOtp({
    required SendEmailOtpRequest sendEmailOtpRequest,
  }) async {
    try {
      final response = await _authApiClient.sendChangePassOtp(
          sendEmailOtpRequest: sendEmailOtpRequest) as Map<String, dynamic>;
      if (response['success'] == false) {
        return ApiResponse.error(
            response['message'] ?? "Something Went Wrong!");
      } else if (response['success'] == true) {
        return ApiResponse.success(response['message'] ?? "");
      } else {
        return ApiResponse.error('Something Went Wrong');
      }
    } on DioException catch (e) {
      final hasInternet = await hasInternetAccess();
      if (!hasInternet) {
        return ApiResponse.noInternet();
      }
      return ApiResponse.error(
          e.response?.data['message'] ?? "Sonmething Went Wrong!!!");
    }
  }

  // @override
  // Future<ApiResponse<String>> refreshToken({
  //   required String userId,
  //   required String type,
  // }) async {
  //   try {
  //     final response = await _authApiClient.refreshToken(
  //             refreshTokenRequest: RefreshTokenRequest(id: userId, type: type))
  //         as Map<String, dynamic>;
  //     if (response['success'] == false) {
  //       return ApiResponse.error(
  //           response['message'] ?? "Something Went Wrong!");
  //     } else if (response['success'] == true) {
  //       return ApiResponse.success(response['data']['token']);
  //     } else {
  //       return ApiResponse.error('Something Went Wrong');
  //     }
  //   } on DioException catch (e) {
  //     final hasInternet = await hasInternetAccess();
  //     if (!hasInternet) {
  //       return ApiResponse.noInternet();
  //     }
  //     return ApiResponse.error(
  //         e.response?.data['message'] ?? "Sonmething Went Wrong!!!");
  //   }
  // }

  @override
  Future<ApiResponse<String>> changePassword({
    required SendEmailOtpRequest sendEmailOtpRequest,
  }) async {
    try {
      final response = await _authApiClient.changePassword(
          sendEmailOtpRequest: sendEmailOtpRequest) as Map<String, dynamic>;
      if (response['success'] == false) {
        return ApiResponse.error(
            response['message'] ?? "Something Went Wrong!");
      } else if (response['success'] == true) {
        return ApiResponse.success(response['message'] ?? "");
      } else {
        return ApiResponse.error('Something Went Wrong');
      }
    } on DioException catch (e) {
      final hasInternet = await hasInternetAccess();
      if (!hasInternet) {
        return ApiResponse.noInternet();
      }
      return ApiResponse.error(
          e.response?.data['message'] ?? "Sonmething Went Wrong!!!");
    }
  }

  @override
  Future<ApiResponse<String>> logOut({
    required UserLogoutRequest userLogoutRequest,
  }) async {
    try {
      final response = await _authApiClient.logOut(
          userLogoutRequest: userLogoutRequest) as Map<String, dynamic>;
      // print(response);
      if (response['success'] == false) {
        return ApiResponse.error(
            response['message'] ?? "Something Went Wrong!");
      } else if (response['success'] == true) {
        return ApiResponse.success(response['message']);
      } else {
        return ApiResponse.error('Something Went Wrong');
      }
    } on DioException catch (e) {
      final hasInternet = await hasInternetAccess();
      if (!hasInternet) {
        return ApiResponse.noInternet();
      }
      return ApiResponse.error(
          e.response?.data['message'] ?? "Sonmething Went Wrong!!!");
    }
  }

  @override
  Future<ApiResponse<Map<int, List<CategoryData>>>> getAllCategory({
    required GetListDataRequest getListDataRequest,
  }) async {
    return await safeApiCall<Map<int, List<CategoryData>>>(
      () async => await _basicApiClient.getAllCategory(
          getListDataRequest: getListDataRequest),
      (response) => ApiResponse.success({
        response['other']['total'] as int: ((response['data'] as List?) ?? [])
            .map((e) => CategoryData.fromJson(e))
            .toList()
      }),
    );
  }

  @override
  Future<ApiResponse<Map<int, List<CategoryData>>>> getProductsByCategory({
    required GetListDataRequest getListDataRequest,
  }) async {
    // return await safeApiCall<Map<int, List<CategoryData>>>(
    //   () async => await _basicApiClient.getProductsByCategory(
    //       catId: getListDataRequest.categoryId ?? ''),
    //   (response) => ApiResponse.success({
    //     response['other']['total'] as int: ((response['data'] as List?) ?? [])
    //         .map((e) => CategoryData.fromJson(e))
    //         .toList()
    //   }),
    // );
    return await safeApiCall<Map<int, List<CategoryData>>>(
      () async => await _basicApiClient.getProductsByCategory(
        catId: getListDataRequest.categoryId ?? '',
      ),
      (response) {
        final other = response['other'];
        final total =
            other != null && other['total'] != null ? other['total'] as int : 0;

        final List dataList = response['data'] as List? ?? [];

        final List<CategoryData> categories =
            dataList.map((e) => CategoryData.fromJson(e)).toList();

        return ApiResponse.success({
          total: categories,
        });
      },
    );
  }

  @override
  Future<ApiResponse<Map<int, List<ProductData>>>> getAllProduct({
    required GetListDataRequest getListDataRequest,
  }) async {
    return await safeApiCall<Map<int, List<ProductData>>>(
      () async => await _basicApiClient.getAllProducts(
          getListDataRequest: getListDataRequest),
      (response) => ApiResponse.success({
        response['other']['total'] as int: ((response['data'] as List?) ?? [])
            .map((e) => ProductData.fromJson(e))
            .toList()
      }),
    );
  }

  @override
  Future<ApiResponse<List<FeaturedProduct>>> getAllFeatured({
    required GetListDataRequest getListDataRequest,
  }) async {
    return await safeApiCall<List<FeaturedProduct>>(
      () async => await _basicApiClient.getAllFeatured(
          getListDataRequest: getListDataRequest),
      (response) => ApiResponse.success(((response['data'] as List?) ?? [])
          .map((e) => FeaturedProduct.fromJson(e))
          .toList()),
    );
  }

  @override
  Future<ApiResponse<ProductData>> getProductDetail({
    required GetListDataRequest getListDataRequest,
  }) async {
    return await safeApiCall<ProductData>(
      () async => await _basicApiClient.getProductDetail(
          getListDataRequest: getListDataRequest),
      (response) => ApiResponse.success(
          ProductData.fromJson(response['data']?['product'] ?? {})),
    );
  }

  @override
  Future<ApiResponse<Map<int, List<DiscountData>>>> getAllDiscount({
    required GetListDataRequest getListDataRequest,
  }) async {
    try {
      final response = await _basicApiClient.getAllDiscounts(
          getListDataRequest: getListDataRequest) as Map<String, dynamic>;
      if (response['success'] == false) {
        return ApiResponse.error(
            response['message'] ?? "Something Went Wrong!");
      } else if (response['success'] == true) {
        return ApiResponse.success({
          response['other']['total'] as int: ((response['data'] as List?) ?? [])
              .map((e) => DiscountData.fromJson(e))
              .toList()
        });
      } else {
        return ApiResponse.error('Something Went Wrong');
      }
    } on DioException catch (e) {
      final hasInternet = await hasInternetAccess();
      if (!hasInternet) {
        return ApiResponse.noInternet();
      }
      return ApiResponse.error(
          e.response?.data['message'] ?? "Sonmething Went Wrong!!!");
    }
  }

  @override
  Future<ApiResponse<Map<int, List<ArtistData>>>> getTrendingArtists({
    required GetListDataRequest getListDataRequest,
  }) async {
    try {
      final response = await _basicApiClient.getTrendingArtists(
          getListDataRequest: getListDataRequest) as Map<String, dynamic>;
      if (response['success'] == false) {
        return ApiResponse.error(
            response['message'] ?? "Something Went Wrong!");
      } else if (response['success'] == true) {
        return ApiResponse.success({
          response['other']['total'] as int: ((response['data'] as List?) ?? [])
              .map((e) => ArtistData.fromJson(e))
              .toList()
        });
      } else {
        return ApiResponse.error('Something Went Wrong');
      }
    } on DioException catch (e) {
      final hasInternet = await hasInternetAccess();
      if (!hasInternet) {
        return ApiResponse.noInternet();
      }
      return ApiResponse.error(
          e.response?.data['message'] ?? "Sonmething Went Wrong!!!");
    }
  }

  @override
  Future<ApiResponse<Map<int, List<ArtStyle>>>> getTrendingArtstyle({
    required GetListDataRequest getListDataRequest,
  }) async {
    return await safeApiCall<Map<int, List<ArtStyle>>>(
      () async => await _basicApiClient.getTrendingArtStyle(
          getListDataRequest: getListDataRequest),
      (response) => ApiResponse.success({
        response['other']['total'] as int: ((response['data'] as List?) ?? [])
            .map((e) => ArtStyle.fromJson(e))
            .toList()
      }),
    );
  }

  @override
  Future<ApiResponse<String>> updateFav({
    required String token,
    required GetListDataRequest getListDataRequest,
  }) async {
    try {
      final response = await _basicApiClient.updateFavStatus(
          token: token,
          getListDataRequest: getListDataRequest) as Map<String, dynamic>;

      if (response['success'] == false) {
        return ApiResponse.error(
            response['message'] ?? "Something Went Wrong!");
      } else if (response['success'] == true) {
        return ApiResponse.success(response['message']);
      } else {
        return ApiResponse.error('Something Went Wrong');
      }
    } on DioException catch (e) {
      final hasInternet = await hasInternetAccess();
      if (!hasInternet) {
        return ApiResponse.noInternet();
      }
      return ApiResponse.error(
          e.response?.data['message'] ?? "Sonmething Went Wrong!!!");
    }
  }

  @override
  Future<ApiResponse<List<WishlistProductData>>> getAllFav({
    required String token,
  }) async {
    try {
      final response =
          await _basicApiClient.getAllFav(token: token) as Map<String, dynamic>;
      // print(response['data'].length);
      if (response['success'] == false) {
        return ApiResponse.error(
            response['message'] ?? "Something Went Wrong!");
      } else if (response['success'] == true) {
        return ApiResponse.success(((response['data'] as List?) ?? [])
            .map((e) => WishlistProductData.fromJson(e['product_id']))
            .toList());
      } else {
        return ApiResponse.error('Something Went Wrong');
      }
    } on DioException catch (e) {
      final hasInternet = await hasInternetAccess();
      if (!hasInternet) {
        return ApiResponse.noInternet();
      }
      return ApiResponse.error(
          e.response?.data['message'] ?? "Sonmething Went Wrong!!!");
    }
  }

  @override
  Future<ApiResponse<String>> updateCartData({
    required String token,
    required String productId,
    required int discount,
    required bool add,
  }) async {
    try {
      final response = await _basicApiClient.addProductToCart(
        token: token,
        updateCartDataRequest: UpdateCartDataRequest(
          addRemove: add ? 'add' : 'remove',
          cartData: '{"prod_id":"$productId","discount_value":"$discount"}',
        ),
      );

      // print(response['data'].length);
      if (response['success'] == false) {
        return ApiResponse.error(
            response['message'] ?? "Something Went Wrong!");
      } else if (response['success'] == true) {
        return ApiResponse.success(response['message'] ?? "");
      } else {
        return ApiResponse.error('Something Went Wrong');
      }
    } on DioException catch (e) {
      final hasInternet = await hasInternetAccess();
      if (!hasInternet) {
        return ApiResponse.noInternet();
      }

      return ApiResponse.error(
          e.response?.data['message'] ?? "Sonmething Went Wrong!!!");
    }
  }

  @override
  Future<ApiResponse<List<CartData>>> getAllCart({
    required String token,
  }) async {
    try {
      final response = await _basicApiClient.getAllCart(token: token)
          as Map<String, dynamic>;

      if (response['success'] == false) {
        return ApiResponse.error(
            response['message'] ?? "Something Went Wrong!");
      } else if (response['success'] == true) {
        return ApiResponse.success(((response['data'] as List?) ?? []).isEmpty
            ? []
            : ((response['data'][0]['cart_data'] as List?) ?? [])
                .map((e) => CartData.fromJson(e))
                .toList());
      } else {
        return ApiResponse.error('Something Went Wrong');
      }
    } on DioException catch (e) {
      final hasInternet = await hasInternetAccess();
      if (!hasInternet) {
        return ApiResponse.noInternet();
      }
      return ApiResponse.error(
          e.response?.data['message'] ?? "Sonmething Went Wrong!!!");
    }
  }
}

/// A wrapper for safely calling API methods and standardizing response/error handling.
///
/// This function:
/// - Executes the provided `call` which must return a `Map<String, dynamic>`
/// - Intercepts errors like [DioException] and no internet
/// - Returns a wrapped [ApiResponse] for consistent handling
///
/// Example usage:
/// ```dart
/// return safeApiCall<UserData>(
///   () => apiClient.getUser(),
///   (json) => ApiResponse.success(UserData.fromJson(json['data'])),
/// );
/// ```
///
/// Type Parameters:
/// - [T] is the type of the data you expect in [ApiResponse.success]
///
/// Parameters:
/// - [call]: A function that returns the API response as `Map<String, dynamic>`
/// - [onSuccess]: A function that maps the response to an [ApiResponse.success]
/// - [onError] (optional): A function that maps an error to a custom [ApiResponse.error]
///
/// Returns:
/// - A [Future] of [ApiResponse<T>]
Future<ApiResponse<T>> safeApiCall<T>(
  Future<Map<String, dynamic>> Function() call,
  ApiResponse<T> Function(Map<String, dynamic>) onSuccess, {
  ApiResponse<T> Function(Object error)? onError,
}) async {
  try {
    final response = await call();

    if (response['success'] == false) {
      return ApiResponse<T>.error(
          response['message'] ?? "Something Went Wrong!");
    }

    return onSuccess(response);
  } catch (e, stackTrace) {
    log('[API Error] ${e.toString()}');
    log('[StackTrace] $stackTrace');

    final hasInternet = await hasInternetAccess();
    if (!hasInternet) return ApiResponse.noInternet();

    if (e is DioException) {
      return onError?.call(e) ??
          ApiResponse.error(
              e.response?.data['message'] ?? "Something Went Wrong");
    }

    return onError?.call(e) ?? ApiResponse.error("Something Went Wrong");
  }
}
