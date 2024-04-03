import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:take_my_tym/core/utils/app_exception.dart';
import 'package:take_my_tym/features/post/data/models/post_model.dart';

final class GetUserPostsRemoteData {
  Future<List<PostModel>> userBuyTymPosts(String uid) async {
    try {
      ///From the usersPost
      final postIds = await FirebaseFirestore.instance
          .collection('usersPost')
          .doc(uid)
          .get();

      ///Checking user created posts before
      if (postIds.exists) {
        final data = postIds.data();

        ///If user created post then checking he created post
        if (data != null && data.containsKey("buyTymPost")) {
          ///All the avilable buyTymPost ID collected
          final List<dynamic> buyTymPostIds =
              postIds.data()!['buyTymPost'] as List<dynamic>;

          ///Going to search and Collect the buyTymPostIds from buyTymPosts
          if (buyTymPostIds.isNotEmpty) {
            final buyTymPostsQuery = await FirebaseFirestore.instance
                .collection('buyTymPost')
                .where(FieldPath.documentId, whereIn: buyTymPostIds)
                .get();

            ///Creating PostModel List for user posts
            final buyTymPosts = buyTymPostsQuery.docs
                .map(
                  (doc) => PostModel.fromMap(
                    doc.data(),
                  ),
                )
                .toList();

       log("selltime-> ${buyTymPosts.toString()}");

            return buyTymPosts;
          } else {
            throw const MyAppException();
          }
        } else {
          throw const MyAppException();
        }
      } else {
        throw const MyAppException();
      }
    } catch (e) {
      log(e.toString());
      throw MyAppException(title: e.toString(), message: e.toString());
    }
  }

  Future<List<PostModel>> userSellTymPosts(String uid) async {
    try {
      ///From the usersPost
      final postIds = await FirebaseFirestore.instance
          .collection('usersPost')
          .doc(uid)
          .get();

      ///Checking user created posts before
      if (postIds.exists) {
        final data = postIds.data();

        ///If user ccreated post then checking his created posts
        if (data != null && data.containsKey("sellTymPost")) {
          ///All the avilable sellTymPost ID collected
          final List<dynamic> sellTymPostIds =
              postIds.data()!['sellTymPost'] as List<dynamic>;

          ///Going to search and collect the buytympostIds from buyTymPosts
          if (sellTymPostIds.isNotEmpty) {
            final sellTymPostQuery = await FirebaseFirestore.instance
                .collection("sellTymPost")
                .where(FieldPath.documentId, whereIn: sellTymPostIds)
                .get();

            ///Creating PostModel List for user posts
            final sellTymPosts = sellTymPostQuery.docs
                .map(
                  (doc) => PostModel.fromMap(
                    doc.data(),
                  ),
                )
                .toList();
            log("selltime-> ${sellTymPosts.toString()}");
            return sellTymPosts;
          } else {
            throw const MyAppException();
          }
        } else {
          throw const MyAppException();
        }
      } else {
        throw const MyAppException();
      }
    } catch (e) {
      log(e.toString());
      throw MyAppException(message: e.toString(), title: e.toString());
    }
  }
}
