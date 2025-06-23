import 'package:Artisan/src/models/category_data/category_data.dart';
import 'package:Artisan/src/models/discount_data/discount_data.dart';
import 'package:Artisan/src/models/requests/send_email_otp_request.dart';
import 'package:Artisan/src/models/requests/user_login_request.dart';
import 'package:Artisan/src/models/user_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/api_response.dart';
import '../../../models/artist_data/artist_data.dart';
import '../../../models/cart_data/cart_data.dart';
import '../../../models/product_data/featured_product.dart';
import '../../../models/product_data/product_data.dart';
import '../../../models/requests/get_list_data_request.dart';
import '../../../models/requests/social_login_request.dart';
import '../../../models/requests/user_logout_request.dart';
import '../../../models/user_register_data.dart';
import '../../../models/wishlist_product_data/wishlist_product_data.dart';
import 'api_service_impl.dart';

final apiServiceProvider = Provider<ApiService>(
  (ref) => ApiServiceImpl(),
);

abstract class ApiService {
  //auth-api's
  Future<ApiResponse<UserData>> registerUser({
    required UserRegisterData userData,
  });
  Future<ApiResponse<UserData>> loginUser({
    required UserLoginRequest userLoginRequest,
  });
  Future<ApiResponse<String>> sendOtp({
    required String token,
    required SendEmailOtpRequest sendEmailOtpRequest,
  });
  Future<ApiResponse<String>> updateEmailOtp({
    required String token,
    required SendEmailOtpRequest sendEmailOtpRequest,
  });
  Future<ApiResponse<UserLoggedData>> fetchUserDetails({
    required String token,
  });
  Future<ApiResponse<UserData>> socialLogin({
    required SocialLoginRequest socialLoginRequest,
  });
  Future<ApiResponse<String>> sendForgotPassOtp({
    required SendEmailOtpRequest sendEmailOtpRequest,
  });
  Future<ApiResponse<String>> changePassword({
    required SendEmailOtpRequest sendEmailOtpRequest,
  });

  Future<ApiResponse<String>> verifyOtp({
    required SendEmailOtpRequest sendEmailOtpRequest,
  });
  Future<ApiResponse<String>> logOut({
    required UserLogoutRequest userLogoutRequest,
  });
  // Future<ApiResponse<String>> refreshToken({
  //   required String userId,
  //   required String type,
  // });

  // basic-api's

  Future<ApiResponse<Map<int, List<CategoryData>>>> getAllCategory({
    required GetListDataRequest getListDataRequest,
  });
  Future<ApiResponse<Map<int, List<ProductData>>>> getAllProduct({
    required GetListDataRequest getListDataRequest,
  });
  Future<ApiResponse<List<FeaturedProduct>>> getAllFeatured({
    required GetListDataRequest getListDataRequest,
  });
  Future<ApiResponse<ProductData>> getProductDetail({
    required GetListDataRequest getListDataRequest,
  });
  Future<ApiResponse<Map<int, List<DiscountData>>>> getAllDiscount({
    required GetListDataRequest getListDataRequest,
  });
  Future<ApiResponse<Map<int, List<ArtistData>>>> getAllArtists({
    required GetListDataRequest getListDataRequest,
  });

  Future<ApiResponse<String>> updateFav({
    required String token,
    required GetListDataRequest getListDataRequest,
  });
  Future<ApiResponse<List<WishlistProductData>>> getAllFav({
    required String token,
  });
  Future<ApiResponse<String>> updateCartData({
    required String token,
    required String productId,
    required int discount,
    required bool add,
  });
  Future<ApiResponse<List<CartData>>> getAllCart({
    required String token,
  });
}
