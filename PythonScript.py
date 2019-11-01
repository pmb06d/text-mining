# -*- coding: utf-8 -*-
"""
Created on Mon Sep 17 23:28:28 2018

@author: pbonnin
"""

#%%

#  Read in the data

import pandas as p
train=p.read_table("C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/CleanReviewData3.tsv", delimiter='\t')
y=train['DiscRating'].values
X=train['MContent'].values


# Hold out 40% of examples for testing
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.4, random_state=0)


print(X_train.shape, y_train.shape, X_test.shape, y_test.shape)

#%%

# Marginal distribution

from scipy.stats import itemfreq
print("Training set:")
print(itemfreq(y_train))

print("Full set:")
print(itemfreq(y))

#%%

# Task 1: Create some unigram vectorizers

from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer

MinTermFreq = 5

#  unigram boolean vectorizer, minimum document frequency = 5
unigram_bool_vectorizer = CountVectorizer(encoding='latin-1', binary=True, min_df=MinTermFreq, stop_words='english')

#  unigram term frequency vectorizer, minimum document frequency = 5
unigram_count_vectorizer = CountVectorizer(encoding='latin-1', binary=False, min_df=MinTermFreq, stop_words='english')

#  normalized unigram term frequency vectorizer, (tfidf vectorizer for normalization) minimum document frequency = 5
unigram_count_l2norm_vectorizer = TfidfVectorizer(encoding='latin-1', use_idf=False, min_df=MinTermFreq, stop_words='english', norm='l2')

#  unigram tfidf vectorizer, set minimum document frequency to 5
unigram_tfidf_vectorizer = TfidfVectorizer(encoding='latin-1', use_idf=True, min_df=MinTermFreq, stop_words='english')

#%%

# import the NB models and initialize them into variables

from sklearn.naive_bayes import MultinomialNB
multiNB_clf = MultinomialNB()

from sklearn.naive_bayes import BernoulliNB
bernNB_clf = BernoulliNB()

from sklearn.svm import LinearSVC
svm_clf = LinearSVC(C=1)


#%%


# Use cross validation to find the best vectorization method for each algorithm
# Best for MNB (Bernoulli model will be used for boolean representation)

from sklearn.pipeline import Pipeline
from sklearn.model_selection import cross_val_score
import numpy as np

scores = []
labels = []

unigramBernie = Pipeline([('vect', unigram_bool_vectorizer),('nb', bernNB_clf)])
bernouli_score = cross_val_score(unigramBernie, X, y, cv=3)
scores.append(np.mean(bernouli_score))
labels.append("bernouli boolean unigram")

mNB_tf = Pipeline([('vect', unigram_count_vectorizer),('nb', multiNB_clf)])
mNB_tf_score = cross_val_score(mNB_tf, X, y, cv=3)
scores.append(np.mean(mNB_tf_score))
labels.append("mNB unigram tf")

mNB_ntf = Pipeline([('vect', unigram_count_l2norm_vectorizer),('nb', multiNB_clf)])
mNB_ntf_score = cross_val_score(mNB_ntf, X, y, cv=3)
scores.append(np.mean(mNB_ntf_score))
labels.append("mNB unigram l2 tf")

mNB_tfidf = Pipeline([('vect', unigram_tfidf_vectorizer),('nb', multiNB_clf)])
mNB_tfidf_score = cross_val_score(mNB_tfidf, X, y, cv=3)
scores.append(np.mean(mNB_tfidf_score))
labels.append("mNB unigram tfidf")

# Best for SVM 

booleanSVM = Pipeline([('vect', unigram_bool_vectorizer),('nb', svm_clf)])
booleanSVM_score = cross_val_score(booleanSVM, X, y, cv=3)
scores.append(np.mean(booleanSVM_score))
labels.append("svm boolean unigram")

svm_tf = Pipeline([('vect', unigram_count_vectorizer),('nb', svm_clf)])
svm_tf_score = cross_val_score(svm_tf, X, y, cv=3)
scores.append(np.mean(svm_tf_score))
labels.append("svm unigram tf")

svm_ntf = Pipeline([('vect', unigram_count_l2norm_vectorizer),('nb', svm_clf)])
svm_ntf_score = cross_val_score(svm_ntf, X, y, cv=3)
scores.append(np.mean(svm_ntf_score))
labels.append("svm unigram l2 tf")

svm_tfidf = Pipeline([('vect', unigram_tfidf_vectorizer),('nb', svm_clf)])
svm_tfidf_score = cross_val_score(svm_tfidf, X, y, cv=3)
scores.append(np.mean(svm_tfidf_score))
labels.append("svm unigram tfidf")

preTask_CV = sorted(zip(scores,labels),reverse=True)

for i in preTask_CV:
    print(i)
    

# Best for SVM is normalized TF unigrams


#%%

# Task 2: Add a set of bi-gram vectorizers

#  n-gram boolean vectorizer, minimum document frequency = 5
gram12_bool_vectorizer = CountVectorizer(encoding='latin-1', ngram_range=(1,2), binary=True, min_df=MinTermFreq, stop_words='english')

#  n-gram term frequency vectorizer, minimum document frequency = 5
gram12_count_vectorizer = CountVectorizer(encoding='latin-1', ngram_range=(1,2), min_df=MinTermFreq, stop_words='english')

#  normalized n-gram term frequency vectorizer, minimum document frequency = 5
gram12_count_l2norm_vectorizer = TfidfVectorizer(encoding='latin-1', ngram_range=(1,2), use_idf=False, min_df=MinTermFreq, stop_words='english', norm='l2')

#  n-gram tfidf vectorizer, minimum document frequency = 5
gram12_tfidf_vectorizer = TfidfVectorizer(encoding='latin-1', ngram_range=(1,2), norm='l2', use_idf=True, min_df=MinTermFreq, stop_words='english')

#%%

# mNB ngram models 

gram12Bernie = Pipeline([('vect', gram12_bool_vectorizer),('nb', bernNB_clf)])
bernouli_score2 = cross_val_score(gram12Bernie, X, y, cv=3)
scores.append(np.mean(bernouli_score2))
labels.append("bernouli boolean gram12")

mNB_tf = Pipeline([('vect', gram12_count_vectorizer),('nb', multiNB_clf)])
mNB_tf_score2 = cross_val_score(mNB_tf, X, y, cv=3)
scores.append(np.mean(mNB_tf_score2))
labels.append("mNB gram12 tf")

mNB_ntf = Pipeline([('vect', gram12_count_l2norm_vectorizer),('nb', multiNB_clf)])
mNB_ntf_score2 = cross_val_score(mNB_ntf, X, y, cv=3)
scores.append(np.mean(mNB_ntf_score2))
labels.append("mNB gram12 l2 tf")

mNB_tfidf = Pipeline([('vect', gram12_tfidf_vectorizer),('nb', multiNB_clf)])
mNB_tfidf_score2 = cross_val_score(mNB_tfidf, X, y, cv=3)
scores.append(np.mean(mNB_tfidf_score2))
labels.append("mNB gram12 tfidf")

# SVM ngram models 

booleanSVM = Pipeline([('vect', gram12_bool_vectorizer),('nb', svm_clf)])
booleanSVM_score2 = cross_val_score(booleanSVM, X, y, cv=3)
scores.append(np.mean(booleanSVM_score2))
labels.append("svm boolean gram12")

svm_tf = Pipeline([('vect', gram12_count_vectorizer),('nb', svm_clf)])
svm_tf_score2 = cross_val_score(svm_tf, X, y, cv=3)
scores.append(np.mean(svm_tf_score2))
labels.append("svm gram12 tf")

svm_ntf = Pipeline([('vect', gram12_count_l2norm_vectorizer),('nb', svm_clf)])
svm_ntf_score2 = cross_val_score(svm_ntf, X, y, cv=3)
scores.append(np.mean(svm_ntf_score2))
labels.append("svm gram12 l2 tf")

svm_tfidf = Pipeline([('vect', gram12_tfidf_vectorizer),('nb', svm_clf)])
svm_tfidf_score2 = cross_val_score(svm_tfidf, X, y, cv=3)
scores.append(np.mean(svm_tfidf_score2))
labels.append("svm gram12 tfidf")

preTask_CV = sorted(zip(scores,labels),reverse=True)

for i in preTask_CV:
    print(i)
    
#%%
    
# Best unigram SVM
X_train_vec2 = unigram_count_l2norm_vectorizer.fit_transform(X_train)
X_test_vec2 = unigram_count_l2norm_vectorizer.transform(X_test)

svm_clf.fit(X_train_vec2,y_train)
y_pred2 = svm_clf.fit(X_train_vec2, y_train).predict(X_test_vec2)

feature_ranks = sorted(zip(svm_clf.coef_[0], unigram_count_l2norm_vectorizer.get_feature_names()))
low_features = sorted(feature_ranks[-25:],reverse=True)
high_features = feature_ranks[:25]
print("Low rating features:")
for i in low_features:
    print(i)
    
print("High rating features:")
for i in high_features:
    print(i)

#feature_ranks2 = sorted(zip(svm_clf.coef_[0], unigram_count_l2norm_vectorizer.get_feature_names()))
#avg_features = feature_ranks2[-20:]
#print("High rating features:")
#for i in avg_features:
#    print(i)
    
#feature_ranks3 = sorted(zip(svm_clf.coef_[1], unigram_count_l2norm_vectorizer.get_feature_names()))
#low_features = feature_ranks3[-20:]
#print("Low rating features:")
#for i in low_features:
#    print(i)

print("Accuracy:")
print(svm_clf.score(X_test_vec2,y_test))

from sklearn.metrics import classification_report
print(classification_report(y_test, y_pred2))

#%%

