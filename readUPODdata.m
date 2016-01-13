function [baseLineVOC, CO2, fig1, fig2,e2v_O3, e2v_NO2] = readUPODdata(out)

    %fprintf(s, mode);
    
    %Read values from UPOD    
    baseLineVOC = fscanf(out.s, '%u');
    CO2 = fscanf(out.s, '%u');
    fig1 = fscanf(out.s, '%u');
    fig2 = fscanf(out.s, '%u');
    e2v_O3 = fscanf(out.s, '%u');
    e2v_NO2 = fscanf(out.s, '%u');    
    
end
    