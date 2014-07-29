function [MAP]=diverging_moreland(Crgb1, Crgb2)
% Crgb1=[160,4,38]/256*.9;
% Crgb2=[59/256, 76/256, 192/256]*.9;

for i=1:256
    COLORS(i,:)= diverging_moreland( Crgb1, Crgb2, i/256 );
end
colormap(double(COLORS))


function [ MAP_COLOR ] = diverging_moreland( Crgb1, Crgb2, interp )
%DIVERGING_MORELAND  This function produces colormaps based on the article
%% "Diverging Color Maps for Scientific Visualization" by Kenneth Moreland
%colors in form {r1, g1, b1}, {r2, g2, b2}
%interp is the location in the 0-1 range that you want the color to represent
%Transform actual data onto the 0-1 range.

if (~(interp>=0&&interp<=1))
    error('Interp must be between 0 and 1')
end

if (size(Crgb1)~=[1,3]) | max(max(Crgb1))>1 | min(min(Crgb1))<0
    error('colors must be 1x3 matrices in the 0-1 range')
end


Cmsh1 = RGB2Msh(Crgb1);
Cmsh2 = RGB2Msh(Crgb2);
CmshM=[0,0,0];

% If points saturated and distinct, place white in middle
if( (Cmsh1(2) > 0.05) && (Cmsh2(2) > 0.05) && (abs(Cmsh1(3)-Cmsh2(3)) > pi/3 ))
    CmshM(1)=max([Cmsh1(1), Cmsh2(1),88]);
    
    if (interp < 1/2)
        Cmsh2(1) = CmshM(1);
        Cmsh2(2) = 0;
        Cmsh2(3) = 0;
        interp = 2*interp;
    else
        Cmsh1(1) = CmshM(1);
        Cmsh1(2) = 0;
        Cmsh1(3) = 0;
        interp = 2*interp-1;
    end
    
end


%Adjust hue of unsaturated colors
if((Cmsh1(2)<0.05)&&(Cmsh2(2)>0.05))
    Cmsh1(3) = AdjustHue(Cmsh2, Cmsh1(1));
elseif ((Cmsh2(2) < 0.05) && (Cmsh1(2) > 0.05))
    Cmsh2(3) = AdjustHue(Cmsh1, Cmsh2(1));
end

% Linear interpolation on adjusted control points
CmshM = (1-interp)*Cmsh1 + interp*Cmsh2;
MAP_COLOR=(Msh2RGB(CmshM));

%%%%%%%%%% Supporting Functions %%%%%%%%%%%%%%%%%%%%
    function [Cmsh]=CIELAB2Msh(Ccielab)
        Cmsh=[0,0,0];
        Cmsh(1)=sqrt(sum(Ccielab.*Ccielab));
        Cmsh(2)=acos(Ccielab(1)/Cmsh(1));
        Cmsh(3)=atan2(Ccielab(3),Ccielab(2));
    end

    function [Cmsh]=RGB2Msh(Crgb)
        [Ccielab(1), Ccielab(2), Ccielab(3)]=RGB2Lab(Crgb(1), Crgb(2), Crgb(3));
        [Cmsh]=CIELAB2Msh(Ccielab);
    end
                
    function [Ccielab]=Msh2CIELAB(Cmsh)
        Ccielab=[0,0,0];
        Ccielab(1)=Cmsh(1)*cos(Cmsh(2));
        Ccielab(2)=Cmsh(1)*sin(Cmsh(2))*cos(Cmsh(3));
        Ccielab(3)=Cmsh(1)*sin(Cmsh(2))*sin(Cmsh(3));
    end
            
    function [Crgb]=Msh2RGB(Cmsh)
        Ccielab=Msh2CIELAB(Cmsh);
        [Crgb(1), Crgb(2), Crgb(3)] = Lab2RGB(Ccielab(1), Ccielab(2), Ccielab(3));
    end

    function [HUE]=AdjustHue(CmshS, mUS)
        if (CmshS(1) >= mUS)
            HUE=(CmshS(3)); 	%Best we can do
        else
            h_spin=CmshS(2)*sqrt(mUS^2-CmshS(1)^2)/(CmshS(1)*sin(CmshS(2)));
            if(CmshS(3)>-pi/3)
                HUE=(CmshS(3)+h_spin);
            else
                HUE=(CmshS(3)-h_spin);
            end
        end
    end

end
