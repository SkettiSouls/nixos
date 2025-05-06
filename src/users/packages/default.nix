{ withArgs, ... }:

{
  # Change this to switch methods (see README)
  imports = [(withArgs ./per-system {})];
}
