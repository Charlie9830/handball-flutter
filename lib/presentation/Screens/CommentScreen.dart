import 'package:flutter/material.dart';
import 'package:handball_flutter/models/CommentScreenViewModel.dart';
import 'package:handball_flutter/presentation/CommentPanel/CommentInput.dart';
import 'package:handball_flutter/presentation/CommentPanel/CommentPanel.dart';

class CommentScreen extends StatefulWidget {
  final CommentScreenViewModel viewModel;
  const CommentScreen({Key key, this.viewModel}) : super(key: key);

  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleWillPop,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: widget.viewModel.onClose,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: Column(
              children: <Widget>[
                Expanded(
                  child: CommentPanel(
                    isPaginationComplete: widget.viewModel.isPaginationComplete,
                    isGettingComments: widget.viewModel.isGettingComments,
                    onPaginate: widget.viewModel.onPaginate,
                    viewModels: widget.viewModel.commentViewModels,
                    scrollController: _scrollController,
                  ),
                ),
                CommentInput(
                  onPost: _handlePost,
                )
              ],
            )),
      ),
    );
  }

  _handlePost(text) {
    widget.viewModel.onPost(text);
  }

  Future<bool> _handleWillPop() {
    widget.viewModel.onClose();

    return Future.value(false);
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }
}
