{ withArgs, ... }:

{
  config.flake.users = {
    skettisouls = {
      homeModule = withArgs ./home-manager {};
      wrapperModule = withArgs ./wrapper-manager {};
    };
  };
}
