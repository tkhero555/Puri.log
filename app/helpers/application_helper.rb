module ApplicationHelper
  def full_title(page_title = '')
    base_title = "Puri.log"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def default_meta_tags
    {
      site: 'Puri.log',
      title: 'Puri.log',
      reverse: true,
      charset: 'utf-8',
      description: '食事と排便の記録を分析する健康管理アプリ',
      keywords: '食事管理,腸活,排便管理',
      canonical: request.original_url,
      separator: '|',
      icon: [
        { href: image_url('favicon.ico') },
        { href: image_url('purilog_square.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/png' },
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('purilog_top_image.png'),# 配置するパスやファイル名によって変更する
        local: 'ja-JP',
      },
      twitter: {
        card: 'summary_large_image', # Twitterで表示する場合は大きいカードに変更
        site: '@', # アプリの公式Twitterアカウントがあれば、アカウント名を記載
        image: image_url('purilog_top_image.png'),# 配置するパスやファイル名によって変更
      }
    }
  end
end
