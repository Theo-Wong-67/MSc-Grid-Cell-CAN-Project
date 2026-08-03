
clear
load('grid_polars_CORRECTED_BAD_CELLS.mat')

count = 1;
for i = 1:60
    
    p = wtycorrect{i,2};
    
    pax = subplot(6,14,count, polaraxes);
    polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
    pax.RGrid  = 'off';
    pax.RTickLabels = [];
    set(gcf,'color','w');
    
    padsize = 110;
    p = wtycorrect{i,3};
    
    subplot(6,14,count+14);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square
    
    
    p = wty_data2{i,2};
    
    pax = subplot(6,14,count+28, polaraxes);
    polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
    pax.RGrid  = 'off';
    pax.RTickLabels = [];
    set(gcf,'color','w');
    
    padsize = 110;
    p = wty_data2{i,4};
    
    subplot(6,14,count+42);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square

    count = count + 1;
end


%wta
count = 1;
for i = 1:60
    
    p = wtacorrect{i,2};
    
    pax = subplot(6,14,count, polaraxes);
    polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
    pax.RGrid  = 'off';
    pax.RTickLabels = [];
    set(gcf,'color','w');
    
    padsize = 110;
    p = wtacorrect{i,3};
    
    subplot(6,14,count+28);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square
    count = count + 1;

end

%wta after correction


%wta
count = 1;
for i = 1:60
    
    p = wta_data2{i,2};
    
    pax = subplot(6,14,count, polaraxes);
    polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
    pax.RGrid  = 'off';
    pax.RTickLabels = [];
    set(gcf,'color','w');
    
    padsize = 110;
    p = wta_data2{i,4};
    
    subplot(6,14,count+28);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square

    count = count + 1;
end


% APP
count = 1;
for i = 1:60
    
    p = j20ycorrect{i,2};
    
    pax = subplot(6,14,count, polaraxes);
    polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
    pax.RGrid  = 'off';
    pax.RTickLabels = [];
    set(gcf,'color','w');
    
    padsize = 110;
    p = j20ycorrect{i,3};
    
    subplot(6,14,count+14);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square
    
    
    p = j20y_data2{i,2};
    
    pax = subplot(6,14,count+28, polaraxes);
    polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
    pax.RGrid  = 'off';
    pax.RTickLabels = [];
    set(gcf,'color','w');
    
    padsize = 110;
    p = j20y_data2{i,4};
    
    subplot(6,14,count+42);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square

    count = count + 1;
end


%j20a
count = 1;
for i = 1:60
    
    p = j20acorrect{i,2};
    
    pax = subplot(6,14,count, polaraxes);
    polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
    pax.RGrid  = 'off';
    pax.RTickLabels = [];
    set(gcf,'color','w');
    
    padsize = 110;
    p = j20acorrect{i,3};
    
    subplot(6,14,count+28);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square
    count = count + 1;

end

%j20a after correction


%j20a
count = 1;
for i = 1:60
    
    p = j20a_data2{i,2};
    
    pax = subplot(6,14,count, polaraxes);
    polarplot(p(:,1), p(:,2),'k','LineWidth',2)
%     pax.ThetaGrid  = 'off';
    pax.RGrid  = 'off';
    pax.RTickLabels = [];
    set(gcf,'color','w');
    
    padsize = 110;
    p = j20a_data2{i,4};
    
    subplot(6,14,count+28);
    imagesc(p(padsize-16:end-padsize+16,padsize-16:end-padsize+16))
    colormap jet
    axis square

    count = count + 1;
end
