% -----------------------------------------------------------------
%  Robot Parameters
% -------------------------------------------------------------------
H = 115;        % 115 mm
L = 108;        % 107.8 mm
R = 108;        % 107.8 mm
R_L = 49;       % 50 mm
R_R = 51;       % 50 mm
R_3 = 52;       % 50 mm
d_xc = 56;      % 25.79 mm
d_yc = 10;       % 0 mm
m_p = 2.8;      % 0.75 kg
m_L = 1.2;      % 1.15 kg
m_R = 1.2;      % 1.15 kg
m_3 = 0.6;      % 0.55 kg
I_p = 6430;     % 6428.68 kg-sq. mm
I_L = 350;      % 351.882 kg-sq. mm
I_R = 350;      % 351.882 kg-sq. mm
I_3 = 655;      % 653.657 kg-sq. mm
I_wL = 629;     % 628.378 kg-sq. mm
I_wR = 629;     % 628.378 kg-sq. mm
I_w3 = 629;     % 628.378 kg-sq. mm

maxTorque = 0; % 0 for unrestricted torque

% -------------------------------------------------------------------
%  Controller Robot Parameters
% -------------------------------------------------------------------

Controller_H = 115;
Controller_I_3 = 653.657;
Controller_I_L = 351.882;
Controller_I_R = 351.882;
Controller_I_p = 6428.68;
Controller_I_w3 = 628.378;
Controller_I_wL = 628.378;
Controller_I_wR = 628.378;
Controller_L = 107.8;
Controller_R = 107.8;
Controller_R_3 = 50;
Controller_R_L = 50;
Controller_R_R = 50;
Controller_d_xc = 25.79;
Controller_d_yc = 0;
Controller_m_3 = 0.55;
Controller_m_L = 1.15;
Controller_m_R = 1.15;
Controller_m_p = 0.75;

% -------------------------------------------------------------------
%  Controller Parameters  %% HOW TO OPTIMIZE???
% -------------------------------------------------------------------
K_x = 10;               % unit/s
K_theta = 0.016;         % unit/mm
K_y = 0.000064;           % unit/mm^2
K_eta = diag([1, 1]) * 1.732;  % [ unit/s , unit/s ]
K_eta_d = diag([1, 1]) * 0.5;  % [ unit , unit ]
K_eta_i = diag([1, 1]) * 0.5;  % [ unit , unit ]