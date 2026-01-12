function draw_scatter_plot(feature, feature_name, label)
% Quetsa funzione disegna lo scatter plot di una feature e della label.
% 
% Input:
% - feature è la feature da mostrare
% - feature_name è il nome della feature
% - label è la label dei campioni

figure;

scatter(feature, label, 36, 'filled', 'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.1);

xlabel(feature_name, 'Interpreter', 'none');
ylabel('Label', 'Interpreter', 'none');
title("Scatter plot: " + feature_name + " vs Label");

end

