import 'package:handball_flutter/models/Comment.dart';

class CommentScreenViewModel {
  final bool isPaginationComplete;
  final List<CommentViewModel> commentViewModels;
  final bool isGettingComments;
  final dynamic onPost;
  final dynamic onPaginate;
  final dynamic onClose;

  CommentScreenViewModel({
    this.isPaginationComplete,
    this.isGettingComments,
    this.commentViewModels,
    this.onPost,
    this.onPaginate,
    this.onClose,
  });
}