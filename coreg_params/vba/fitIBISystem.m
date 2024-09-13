function [posterior, out] = fitIBISystem(file, showfig, include_is_Y_out)
%I believe we should be able to use the g_Id observation function
%This is just an identity mapping that is matrix-compatible.
%It allows for a scaling parameter: inG.scale that multiplies the state
%vector by some scalar value. Not sure how useful this would be.

%file='/storage/home/mnh5174/Tresors/Couples_Interaction/example_dyad_ibis.txt';
%file='/Users/michael/Tresors/Couples_Interaction/example_dyad_ibis.txt';
%file='/Users/ams939/Box Sync/DEPENd/Couples Data/data/example_dyad_ibis.txt';

if showfig == 1
    options.DisplayWin = 1;
else
    options.DisplayWin = 0;
end

data = dlmread(file);

%assuming PTNUM, time, l_ibi_interp_detrend, r_ibi_interp_dtrend (l =
%child/r = caregiver)
id = data(1,1);
data = data(:,[3 4]); %all possibilities - child 1 / caregiver = 2
if regexp(file, "negint")> 1
    int = "neg";
elseif regexp(file, "neuint") > 1
    int =   "neu";
elseif regexp(file, "posint") > 1
    int = "pos";
else
    int = "ERR";
end

%reduce to first 60 seconds for initial tests
%data = data(1:1200,1);
%y = data(:,1)'; %individual oscillator
%y = data(1:100,:)';
%data = data(1:800,:);
y = data';

if (include_is_Y_out == 1)
    options.isYout = zeros(size(y));
    
    if (id == 1034)
        if (int == "neg")
            options.isYout(2, [535:550, 2650:2980, 5780:5800]) = 1; % need to go back through and specify if child or caregiver
        elseif (int == "neu")
            options.isYout(2, [415:430, 1945:1955, 2180:2200]) = 1;
        elseif (int == "pos")
            options.isYout(2, [355:370, 625:640, 785:800, 2725:2740, 3125:3140, 3235:3250, 4155:4165, 4795:4803]) = 1;
        end
    elseif (id == 2021)
        if (int == "neg")
            options.isYout(1, [1430:1460, 2465:2475, 3900:3925]) = 1;
        end
    elseif (id == 2035)
        if (int == "neg")
            options.isYout(1, 3545:3575) = 1;
        end
    elseif (id == 2047) %neg and neu
        if (int == "neg")
            options.isYout(1, 4870:4890) = 1;
        end
    elseif (id == 1002)
        if (int == "neu")
            options.isYout(1, 5580:5605) = 1;
        end
    elseif (id == 1008)
        if (int == "neu")
            options.isYout(1, 4495:4510) = 1;
            options.isYout(2, 625:645) = 1;
        end
    elseif (id == 1013)
        if (int == "neu")
            options.isYout(2, 2165:2190) = 1;
        end
    elseif (id == 2001)
        if(int == "neu")
            options.isYout(1, 4040:4060) = 1;
        end
    elseif (id == 2020)
        if(int == "neu")
            options.isYout(2, 4375:4390) = 1;
        end
    elseif (id == 2023)
        if(int == "neu")
            options.isYout(2, 5395:5305) = 1;
        end
    elseif (id == 2027)
        if(int == "neu")
            options.isYout(2, 315:340) = 1;
        end
    elseif (id == 2040)
        if(int == "neu")
            options.isYout(1, 1730:1750) = 1;
        end
    elseif (id == 1012)
        if(int == "pos")
            options.isYout(1, 2810:2835) = 1;
        end
    elseif (id == 2014)
        if(int == "pos")
            options.isYout(2, 2530:2550) = 1;
        end
    elseif (id == 2045)
        if(int == "pos")
            options.isYout(1, 4110:4130) = 1;
        end
    elseif (id == 10092)
        if(int == "pos")
            options.isYout(1, 595:610) = 1;
        end
        
    end
    
end

delta_t = 0.1; %10Hz series

inF.p1star = 0; %since the IBIs were demeaned and detrended in R, for now, default to 0 equilibrium
inF.p2star = 0;
inF.deltat=delta_t;
options.inF = inF;
n_t = size(data, 1);
%add in if statement so that dim.n_theta reflects the actual number of
%parameters being estimated
dim.n_theta = 4;

dim.n_phi = 0; %identity observation function
dim.n = size(data, 2); %number of physiological signals

options.backwardLag = 16; %number of observations to consider in making prediction of next sample (lagged Kalman filter)

%priors.muX0 = 0*ones(dim.n, 1); %initial IBI signal values. If not demeaned, might be avg IBI value
priors.muX0 = [y(1,1); y(2,1)]; %use observed initial values of IBI series
priors.SigmaX0 = 100*eye(dim.n); %zero covariance in prior. sd of 10 in initial states (since it should be close to observed)
priors.muTheta = 0*ones(dim.n_theta, 1);
priors.SigmaTheta = eye(dim.n_theta); %all coupling parameters are zero centered and max ~1.0

%fit deterministic system
%priors.a_alpha = Inf;
%priors.b_alpha = 0;
priors.a_alpha = 1e0;
priors.b_alpha = 1e1;
priors.a_sigma = 1e1;
priors.b_sigma = 1e1;
options.priors = priors;
f_fname = @VAR_dynphysio_evolution;
g_fname = @g_Id;
u = zeros(1, n_t);

[posterior,out] = VBA_NLStateSpaceModel(y,u,f_fname,g_fname,dim,options);
hfp = findobj('tag','VBNLSS');
set(hfp,'tag','0','name','inversion with delays');