import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/material.dart';
import 'package:my_di_card/models/utility_dto.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/card_get_model.dart';
import '../../models/card_list.dart';
import '../../models/company_type_model.dart';
import '../../models/group_member_model.dart';
import '../../models/group_response.dart';
import '../../models/login_dto.dart';
import '../../models/social_data.dart';
import '../../models/tag_model.dart';
import '../../models/team_member.dart';
import '../../models/team_response.dart';
import '../../models/user_data_model.dart';
import '../../utils/widgets/network.dart';
part 'rest_client.g.dart';

@RestApi(baseUrl: Network.baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  static const header = [
    "Accept: application/json",
    "Content-Type: application/json"
  ];
  static const headerValue = "Accept: application/json";
  static const headerContentType = "Content-Type: application/json";
  static const authorization = "Authorization";

  // @GET("base.json")
  // @Header(headerValue)
  // Future<HttpResponse<BaseUrlDto>> apiBaseUrl();

  @POST("{url}auth/signup")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<UtilityDto>> apiSignUp(@Path("url") url,
       @Body() body);

  @POST("{url}auth/login")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<LoginDto>> apiSignIn(@Path("url") url,
       @Body() body);


@GET("{url}user")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<User>> apiUserProfile(@Path("url") url,
    @Header(authorization) token);


  @POST("{url}oauth/google/login/callback")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<LoginDto>> apiSignupGoogle(@Path("url") url,
       @Body() body);


@POST("{url}oauth/apple/login/callback")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<LoginDto>> apiSignupApple(@Path("url") url,
       @Body() body);

@POST("{url}auth/verify-code")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<LoginDto>> otpRegisterApi(@Path("url") url,
       @Body() body);


@POST("{url}auth/resend-verify-code")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<UtilityDto>> otpResendApi(@Path("url") url,@Body() body);


  @POST("{url}user/complete-profile")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<LoginDto>> completeProfileApi(@Path("url") url,
      @Body() body, @Header(authorization) token);

 @POST("{url}card/update/{id}")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<UtilityDto>> cardUpdateApi(@Path("url") url,
      @Body() body, @Header(authorization) token,  @Path("id") id,);


  @GET("{url}companytype/get")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<CompanyTypeModel>> apiGetCompanyType(@Path("url") url,
      @Header(authorization) token);

  @GET("{url}card/get/{cardId}")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<GetCardModel>> apiGetCard(@Path("url") url,
      @Header(authorization) token,@Path("cardId") id,);

  @GET("{url}card/get-my-card")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<CardListModel>> apiGetMyCard(@Path("url") url,
      @Header(authorization) token,);

  @GET("{url}socials")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<Social>> apiGetSocials(@Path("url") url,
      @Header(authorization) token);


  @POST("{url}card/destroy/{id}")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<UtilityDto>> apiDeleteCard(@Path("url") url,
      @Header(authorization) token,@Path("id") id,);


  @POST("{url}team/update/{id}")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<UtilityDto>> apiCreateUpdateTeam(@Path("url") url,
      @Header(authorization) token,@Body() body,@Path("id") id,);

  @GET("{url}team/get-my-team")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<TeamResponse>> apiGetMyTeam(@Path("url") url,
      @Header(authorization) token);


 @POST("{url}team/get-team-member")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<TeamMembersResponse>> apiGetTeamMember(@Path("url") url,
      @Header(authorization) token,@Body() body,);


 @POST("{url}team/remove-from-team-member")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<UtilityDto>> apiRemoveTeamMember(@Path("url") url,
      @Header(authorization) token,@Body() body,);


 @POST("{url}team/approve-team-member")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<UtilityDto>> apiApproveTeamMember(@Path("url") url,
      @Header(authorization) token,@Body() body,);


 @POST("{url}team/get-unapproved-team-member")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<UtilityDto>> apiGetUnApproveTeamMember(@Path("url") url,
      @Header(authorization) token,@Body() body,);


 @POST("{url}group/store")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<UtilityDto>> apiCreateGroup(@Path("url") url,
      @Header(authorization) token,@Body() body,);


 @POST("{url}group/update/{id}")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<UtilityDto>> apiUpdateGroup(@Path("url") url,
      @Header(authorization) token,@Body() body,@Path("id") id,);



  @GET("{url}group/get/{id}")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<GroupDataModel>> apiGetGroupDetails(@Path("url") url,
      @Header(authorization) token,@Path("id") id,);


  @GET("{url}get-my-group")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<GroupDataModel>> apiGetMyGroup(@Path("url") url,
      @Header(authorization) token);


@GET("{url}group/get-group-member/{id}")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<GroupMember>> apiGetGroupMember(@Path("url") url,
      @Header(authorization) token,@Path("id") id,);


@GET("{url}group/get-group-by-team/{id}")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<GroupDataModel>> apiGetGroupByTeam(@Path("url") url,
      @Header(authorization) token,@Path("id") id,);


@POST("{url}team/get-available-member-to-add-in-group")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<GroupMember>> apiGetActiveMemberForGroup(@Path("url") url,
      @Header(authorization) token,);


@POST("{url}group/remove-member")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<UtilityDto>> apiRemoveGroupMember(@Path("url") url,
      @Header(authorization) token,@Body() body,);

@POST("{url}group/swirch-role")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<UtilityDto>> apiSwitchGroupMemberRole(@Path("url") url,
      @Header(authorization) token,@Body() body,);

@POST("{url}group/add-member")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<UtilityDto>> apiAddGroupMember(@Path("url") url,
      @Header(authorization) token,@Body() body,);

@POST("{url}tag/store")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<UtilityDto>> apiAddTag(@Path("url") url,
      @Header(authorization) token,@Body() body,);

  @GET("{url}tag/get/{id}")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<UtilityDto>> apiGetTag(@Path("url") url,
      @Header(authorization) token,@Path("id") id,);

  @GET("{url}tag/get-team-tag")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<TagModel>> apiGetTeamTag(@Path("url") url,
      @Header(authorization) token,);

  @POST("{url}tag/update/{id}")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<UtilityDto>> apiUpdateTag(@Path("url") url,
      @Header(authorization) token,@Body() body,@Path("id") id,);


  @POST("{url}tag/destroy/{id}")
  @Header(headerValue)
  @Header(headerContentType)
  Future<HttpResponse<UtilityDto>> apiDeleteTag(@Path("url") url,
      @Header(authorization) token,@Path("id") id,);

}
