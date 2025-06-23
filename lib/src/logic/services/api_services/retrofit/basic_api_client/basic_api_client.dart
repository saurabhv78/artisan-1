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
    @Body() required GetListDataRequest getListDataRequest,
  });
  @GET('/products/featured/products')
  Future getAllFeatured({
    @Body() required GetListDataRequest getListDataRequest,
  });
  @GET('/products/products')
  Future getAllProducts({
    @Body() required GetListDataRequest getListDataRequest,
  });
  @POST('/products/get_product_detail')
  Future getProductDetail({
    @Body() required GetListDataRequest getListDataRequest,
  });
  @POST('/discount/get_all_app')
  Future getAllDiscounts({
    @Body() required GetListDataRequest getListDataRequest,
  });
  @POST('/artists/get_all_artists_app')
  Future getAllArtists({
    @Body() required GetListDataRequest getListDataRequest,
  });
  @POST('/fav/add_remove_fav')
  Future updateFavStatus({
    @Header('Authorization') required String token,
    @Body() required GetListDataRequest getListDataRequest,
  });
  @POST('/products/products/favourits')
  Future getAllFav({
    @Header('Authorization') required String token,
    // @Body() required SendEmailOtpRequest sendEmailOtpRequest,
  });
  @POST('/cart/add_new_cart')
  Future addProductToCart({
    @Header('Authorization') required String token,
    @Body() required UpdateCartDataRequest updateCartDataRequest,
  });
  @POST('/cart/get_all_carts_app')
  Future getAllCart({
    @Header('Authorization') required String token,
    // @Body() required SendEmailOtpRequest sendEmailOtpRequest,
  });
}
