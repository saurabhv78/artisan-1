import 'package:Artisan/src/models/requests/cart_product_data/cart_product_data.dart';
import 'package:Artisan/src/models/requests/get_list_data_request.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'basic_api_client.g.dart';

//base url
@RestApi(baseUrl: 'http://3.111.86.244:3000/api/v1')
abstract class BasicApiClient {
  factory BasicApiClient(
    Dio dio, {
    String baseUrl,
  }) = _BasicApiClient;

  @POST('/products/Categories')
  Future getAllCategory({
    @Header('Authorization') required String token,
    @Body() required GetListDataRequest getListDataRequest,
  });

  @GET('/products/products/category/{id}')
  Future getProductsByCategory({
    @Path("id") required String catId,
  });

  @GET('/products/featured/products')
  Future getAllFeatured({
    @Header('Authorization') required String token,
    @Body() required GetListDataRequest getListDataRequest,
  });
  @POST('/products/app/products')
  Future getAllProducts({
    @Header('Authorization') required String token,
    @Body() required GetListDataRequest getListDataRequest,
  });
  @POST('/products/products/details')
  Future getProductDetail({
    @Header('Authorization') required String token,
    @Body() required GetListDataRequest getListDataRequest,
  });
  @POST('/products/app/seller/products')
  Future getArtistData({
    @Header('Authorization') required String token,
    @Body() required dynamic sellerId,
  });
  @POST('/products/discount/list')
  Future getAllDiscounts({
    @Header('Authorization') required String token,
    @Body() required GetListDataRequest getListDataRequest,
  });
  @POST('/products/products/trending/artist')
  Future getTrendingArtists({
    @Header('Authorization') required String token,
    @Body() required GetListDataRequest getListDataRequest,
  });

  /// new point
  @POST('/products/artstyle/list')
  Future getTrendingArtStyle({
    @Header('Authorization') required String token,
    @Body() required GetListDataRequest getListDataRequest,
  });
  @POST('/products/favourits/add')
  Future updateFavStatus({
    @Header('Authorization') required String token,
    @Body() required GetListDataRequest getListDataRequest,
  });
  @POST('/products/products/favourits')
  Future getAllFav({
    @Header('Authorization') required String token,
    // @Body() required SendEmailOtpRequest sendEmailOtpRequest,
  });
  @POST('/products/app/cart/Add')
  Future addProductToCart({
    @Header('Authorization') required String token,
    @Body() required UpdateCartDataRequest updateCartDataRequest,
  });
  @POST('/products/app/cart/list')
  Future getAllCart({
    @Header('Authorization') required String token,
    // @Body() required SendEmailOtpRequest sendEmailOtpRequest,
  });
}
