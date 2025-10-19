function  show_numerical_features_scatter_plot(numeric_features, feature_names, Y)
% Questa funzione mostra gli scatter plot della label rispetto alle
% features numeriche
%
% Input:
% - numeric_fetaures è la sottotabella delle features numeriche
% - feature_names è il nome delle features numeriche
% - Y è l'array delle labels


features_num = length(feature_names);

for idx = 1:features_num

    feature = numeric_features{:, idx};
    feature_name = feature_names(idx);
    draw_scatter_plot(feature, feature_name, Y);

end

end

