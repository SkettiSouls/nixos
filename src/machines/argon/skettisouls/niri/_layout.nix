# Niri Layout Config
{
  gaps = 8;
  focus-ring.off = _: {};
  center-focused-column = "never";
  default-column-width.proportion = 0.5;

  preset-column-widths = [
    { proportion = 1.0 / 3.0; }
    { proportion = 1.0 / 2.0; }
    { proportion = 2.0 / 3.0; }
  ];

  struts = {
    top = 4;
    left = 4;
    right = 4;
    bottom = 4;
  };

  border = {
    width = 4;
    urgent-color = "#9b0000";
    active-color = "#9522f0d8";
    inactive-color = "#505050";
  };

  shadow = {
    on = _: {};
    color = "#0007";
    offset = _: {
      props.x = 0;
      props.y = 0;
    };
    softness = 30;
    spread = 5;
    draw-behind-window = false;
  };
}
