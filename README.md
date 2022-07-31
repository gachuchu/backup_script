# 設定ファイルにそってrobocopyでバックアップを実行するbat

robocopyの日本語ログレポートのインデントがずれるのも適当に直します  
インデントのために「コピー済み」のテキストを「COPY済み」に変更しています

整形前：

	                  合計     コピー済み      スキップ       不一致        失敗    Extras
	   ディレクトリ:         7         0         7         0         0         0
	     ファイル:        39         0        39         0         0         0
	      バイト:   290.3 k         0   290.3 k         0         0         0
	       時刻:   0:00:00   0:00:00                       0:00:00   0:00:00
	   終了: 2022年7月31日 14:41:16

整形後：

	                       合計  COPY済み  スキップ    不一致      失敗    Extras 
	    ディレクトリ:         7         0         7         0         0         0 
	        ファイル:        39         0        39         0         0         0 
	          バイト:   290.3 k         0   290.3 k         0         0         0 
	            時刻:   0:00:00   0:00:00                       0:00:00   0:00:00 
	            終了: 2022年7月31日 14:41:16 

## <span style="color:red">免責事項&注意事項</span>

自分の環境・使い方で動けばいいや。で作っているので検証、デバッグが圧倒的に足りていないです。  
本プロジェクトを利用した、または利用できなかった、その他いかなる場合において一切の保障は行いません。  
自己の責任のもとでご利用ください。

## 使い方

1. backup_list.txt.sample を backup_list.txt にリネームかコピー
1. backup_list.txtの中身をサンプルを参考に記載
1. backup.batを実行

## 補足

- ログファイルは実行ごとにlog/backup_YYYYMMDD_hhmmss.logとして作成されます
- logフォルダが存在しない場合は作成されます
- インデント修正用の一時ファイルとして、log/backup_YYYYMMDD_hhmmss.tmpも作成されます（こちらは最終的に削除されます）
- 拙作の[roglotate](https://github.com/gachuchu/roglotate)が、同階層にある場合はそちらを利用してログローテートします（世代は1つまで。旧世代は削除ではなく圧縮）
- /TEE や /L はbackup_list.txtの追加オプションでもつけられますが、オプション解析をミスった場合のために最初はbackup.bat内のrobocopyに直接追記するほうが安全です
