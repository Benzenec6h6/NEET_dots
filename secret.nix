{
  # 1. TPM2 の有効化
  security.tpm2.enable = true;

  # 2. シークレット & エディタ設定
  neet.security.secrets = {
    enable = true;
    backend = "tpm2";
    editor.publicKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGgSIYPGa90KWqpI/BTLo9azoV/RY0EPnQfWXlxPZyXg"
      "age1qrm2vt5ygdvs8zllatdfnlvnnqveuzzq29wydec07gyf8mk83ftsyw2ds6"
    ];
  };

  # 3. Stage 1 (LUKS) シークレット
  /*
  neet.secrets."luks-root-key" = {
    file = ./secrets/luks-root-key.age;
    inInitrd = true;
  };

  # 4. Stage 2 (ユーザーパスワードハッシュ) シークレット
  neet.secrets = {
    "root-password-hash" = {
      file = ./secrets/root-password-hash.age;
    };
    "user-password-hash" = {
      file = ./secrets/neet-password-hash.age;
    };
  };
  */
}
