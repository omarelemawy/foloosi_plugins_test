
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/utils.dart';
import '../../../models/notificattion_model.dart';
import '../../../sharedPreferences.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  static NotificationCubit get(context)=>BlocProvider.of(context);

  List<Notification>? notificationList;

  Future<List<Notification>?> getNotif
      (lang,userId)async{
    emit(GetLoadingNotificationState());
    var response = await Dio().get(
      Utils.Notifications_URL+"?page=1",options:
    Options(headers: {
      "lang":lang,
      "Accept-Language":lang,
       "user":userId
    })
    );
    print(response.data);
    if(response.data["status"]=="success")
    {
      emit(GetSuccessNotificationState());
      return NotificationModel.fromJson(response.data).data;
    }else{
      emit(GetErrorNotificationState(response.data["message"]));
    }
  }

  void getNotifData(lang){
    MySharedPreferences().getUserId().then((value) {
      getNotif(lang,value).then((value) {
        notificationList = value!;
      });
    });
  }


}
