var hooks = require('hooks');
var stash = {};

// JWT認証の場合、ログイン用のAPIをたたいた後に、得られたトークンを保存する。
// それを認証が必要なエンドポイントをテストする前に、ヘッダに付与することで認証をパスできる。
// ただし、dreddはOASを上から順に叩くため、認証用のトークンが返ってくるAPIは上の方に書くべきである。
hooks.after('/auth/login > Login. > 200 > application/json', function (transaction) {
	stash['token'] = JSON.parse(transaction.real.body)['access_token'];
});

// dredd-names.sh を実行して得られる info: の値がリクエストの名前である。
// hooks.before(リクエストの名前, function) のfunction内で対象のリクエストを操作することができる。
hooks.before("/hc > ALB Health-Check Endpoint. > 200 > text/html", function (transaction) {
	transaction.skip = true;
});

// それぞれのリクエストを確認する前の処理
// transaction.skip = true とすると、条件に合ったリクエストのテストをスキップできる
hooks.beforeEach(function (transaction) {
	if (transaction.expected.statusCode === "401") {
		transaction.skip = true;
	};
	if (stash['token'] != undefined) {
		// 401以外が期待されているリクエストにはヘッダにトークンをつける
		if (transaction.expected.statusCode != "401") {
			transaction.request.headers['Authorization'] = "Bearer " + stash['token'];
		};
	};
});
