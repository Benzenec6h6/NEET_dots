{...}: {
  impermanence = {
    enable = true;
    persistPath = "/persist";
    directories = [
      # 1. セキュアブート鍵 (秘密鍵が含まれるため、root 専用で他者閲覧禁止)
      {
        path = "/var/lib/sbctl";
        user = "root";
        group = "root";
        mode = "0700";
      }

      # 2. システムログ (root所有、一般ユーザーは閲覧のみ可能)
      {
        path = "/var/log";
        user = "root";
        group = "root";
        mode = "0755";
      }

      # 3. テスト用ディレクトリ (neet ユーザーが自由に読み書きできる権限)
      {
        path = "/persist-test";
        user = "neet";
        group = "users";
        mode = "0755";
      }

      # 4. ユーザーホームディレクトリ (neet 専用、他者閲覧禁止)
      {
        path = "/home/neet";
        user = "neet";
        group = "users";
        mode = "0700";
      }
    ];
  };
}
