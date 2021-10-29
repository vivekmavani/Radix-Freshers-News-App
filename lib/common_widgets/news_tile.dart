import 'package:flutter/material.dart';
import 'package:radix_freshers/app/home/article_view.dart';

class NewsTile extends StatelessWidget {

      const NewsTile(
      {Key? key,required this.imgUrl,
      required this.desc,
      required this.title,
      required this.content,
      required this.postUrl,
      required this.timeAgo, required  this.channelName}) : super(key: key);
      final String imgUrl, title, desc, content, postUrl, timeAgo,channelName;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
         Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                ArticleView(
                  postUrl: postUrl,
                  channelName : channelName,
                )
        ));
      },
      child: Container(
          margin:const EdgeInsets.only(bottom: 24),
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(6),
                    bottomLeft: Radius.circular(6))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: imgUrl.isNotEmpty ? Image.network(
                      imgUrl,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ) : Image.asset("assets/img/placeholder.jpg"),
                ),
                const  SizedBox(
                  height: 12,
                ),
                Text(
                  title,
                  maxLines: 2,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                const  SizedBox(
                  height: 4,
                ),
                Text(
                  desc,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
                Text(
                    timeAgo,
                    style: const TextStyle(
                        color: Colors.black26,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0)),
                 ExpansionTile(
                  title: const Text('Read more...'),
                 children: [
                    Text(content),
                 ],
                ),
              ],
            ),
          )),
    );
  }
}
