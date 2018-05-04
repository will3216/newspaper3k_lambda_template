import os
import json
import datetime
import nltk
nltk.data.path.append(os.getcwd() + '/nltk_data')
from newspaper import Article

def parse_article(url):
    result = {}
    article = Article(url)
    article.download()
    if (article.download_state == 2):
        article.parse()
        article.nlp()
        return {
            'status': 'ok',
            'data': {
                'source_url': article.source_url,
                'title': article.title,
                'top_image': article.top_image,
                'meta_image': article.meta_img,
                'images': object_to_json(article.images),
                'videos': object_to_json(article.movies),
                'text': article.text,
                'meta_keywords': object_to_json(article.meta_keywords),
                'tags': object_to_json(article.tags),
                'authors': object_to_json(article.authors),
                'publication_date': object_to_json(article.publish_date),
                'meta_description': article.meta_description,
                'meta_lang': article.meta_lang,
                'meta_favicon': article.meta_favicon,
                'nlp_keywords': object_to_json(article.keywords),
                'nlp_summary': article.summary,
            },
        }
    else:
        return {
            'status': 'error',
            'data': {
                'download_exception_msg': article.download_exception_msg,
            },
        }

def object_to_json(object):
    if isinstance(object, set):
        return list(object)
    elif isinstance(object, datetime.datetime):
        return object.strftime('%s')
    else:
        return object

def handler(event, context):
    return parse_article(event['url'])
