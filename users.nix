{...}: {
  imports = [./users];
  neet.users = {
    root = {
      uid = 0;
      gid = 0;
      shell = "/bin/bash";
      home = "/root";
      description = "System Administrator";
      initialHashedPassword = "$y$j9T$jaiy6IlCEWfCt4hUXIqd81$l.4rBBIQs..6wpicaFF9Ir7u80wHc5ZHhht2kh21cgD";
      #hashedPasswordSecret = "root-password-hash";
    };
    neet = {
      uid = 1000;
      gid = 1000;
      shell = "/bin/bash";
      home = "/home/neet";
      description = "Primary User";
      extraGroups = ["audio" "video" "input" "seat" "wheel"];
      initialHashedPassword = "$y$j9T$uIAhQW8gM7hg/vtyIDPn31$jA8TliY91KoGwnLxFEskcy9b.POtd2d2iuag.oeoKf0";
      #hashedPasswordSecret = "neet-password-hash";
    };
  };
}
